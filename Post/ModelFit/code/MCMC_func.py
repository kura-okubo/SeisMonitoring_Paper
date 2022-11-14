import datetime
import os
import time

import numpy as np
import h5py

from scipy.integrate import quad

# For the speed up of integral with Low level calling function
import ctypes
from scipy import LowLevelCallable

import matplotlib as mpl

import emcee # MCMC sampler
import corner

from multiprocessing import Pool, cpu_count

#---Initialization---#
def get_init_param(**modelparam):
    """
    return the pos array for the initial chains of MCMC
    """
    modelcase = modelparam["modelcase"]
    nwalkers = modelparam["nwalkers"]

    if modelcase.lower() == "base":
        # model without linear trend term
        keys = ['a0', 'p1', 'a_precip', 'p2', 't_shiftdays',
                'S1', 'log10tmin1', 'log10tmax1', 'S2', 'log10tmin2',
                'log10tmax2','log_f'] # fix the order

    elif modelcase.lower() == "wlin":
        # model with linear trend
        keys = ['a0', 'p1', 'a_precip', 'p2', 't_shiftdays',
                'S1', 'log10tmin1', 'log10tmax1', 'S2', 'log10tmin2',
                'log10tmax2', 'b_lin', 'log_f'] # fix the order

    else:
        print(f"{modelcase} is not defined. Please check the modelcase.\n")
        exit(1)

    ndim = len(keys)
    pos = [modelparam[x][0] for x in keys] + 1e-4 * np.random.randn(nwalkers, ndim)

    return (pos, ndim, keys)



#---Model Components---#
#1. ---Precipitation and ground water level change---#
def SSW06(precip, phi, a): # originally developped in Julia by Tim Clements
    Nprecip = len(precip)
    expij = [np.exp(-a*x) for x in range(Nprecip)]
    GWL = np.convolve(expij, precip - np.mean(precip), mode='full')[:Nprecip] / phi
    return GWL

def compute_GWLchange(a_SSW06, **modelparam):
    """
    compute the GWL change with demean
    """
    fitting_period_ind = modelparam["fitting_period_ind"]
    phi = 0.05   # porosity is fixed
    GWL = SSW06(np.array(modelparam["precip"])/1e3, phi, a_SSW06)
    GWL = GWL - np.mean(GWL)
    return GWL[fitting_period_ind]


#2. ---Temperature and thermoelastic change---#
def compute_tempshift(shift_days, smooth_winlen = 6, **modelparam):
    """
    compute the shifted time history of temperature with smoothing
    Input:
    t_shiftdays: days to shift the time history of temperature
    smooth_winlen: datapoints of smoothing. e.g. given 15 days sliding window, the winlen is 6 * 15 days = 3 months.
    """
    unix_tvec          = modelparam["unix_tvec"]
    fitting_period_ind = modelparam["fitting_period_ind"]
    temperature        = modelparam["CAVG"] # temperature in degree Celsius

    smooth_temp = np.convolve(temperature, np.ones(smooth_winlen)/smooth_winlen, mode='same')
    T_shift = np.interp(unix_tvec - shift_days*86400, unix_tvec, smooth_temp)
    return T_shift[fitting_period_ind]

#3. ---Coseismic healing---#

def logheal_llc(ts, S, taumin, taumax, lib_int):
    # using Low-level caling function
    # taumin = 0.1 # fix taumin so that healing starts just after incident
    c = ctypes.c_double(ts) # time t as void * userdata
    user_data = ctypes.cast(ctypes.pointer(c), ctypes.c_void_p)
    int1_llc = LowLevelCallable(lib_int.f, user_data) # in this way, only void* is available as argument

    return -S*quad(int1_llc, taumin, taumax, epsabs = 1e-3, epsrel=1e-3)[0] # this tolerance archieves our requirement in accuracy.

def y_heal_llc(t, S, taumin, taumax, unix_tEV, lib_int):
    if t < unix_tEV:
        return 0
    else:
        # compute logheal model
        return logheal_llc(t-unix_tEV, S, taumin, taumax, lib_int)

def compute_y_healing(tvec, S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int):
    """
    return the time history of healing associated with the San Simeon and Parkfield EQ.
    """
    return [y_heal_llc(t, S1, tmin1, tmax1, unix_tSS, lib_int) + y_heal_llc(t, S2, tmin2, tmax2, unix_tPF, lib_int) for t in tvec]

def compute_y_healing_factor(tvec, S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int):
    return ([y_heal_llc(t, S1, tmin1, tmax1, unix_tSS, lib_int) for t in tvec],
            [y_heal_llc(t, S2, tmin2, tmax2, unix_tPF, lib_int) for t in tvec])

#4. ---Linear trend---#
def compute_lineartrend(tvec, b):
    """
    return linear trend with the slope of b, whose unit is [1/day].
    """
    return b * (tvec-tvec[0])/86400 # [1/day]


#---Make model---#
def model_base(theta, all=False, **modelparam):
    """
    dv/v base model without linear trend term.
    """

    # parse the trial model parameters
    assert modelparam["ndim"] == len(theta)
    a0, p1, a_precip, p2, t_shiftdays, S1, log10tmin1, log10tmax1, S2, log10tmin2, log10tmax2, log_f = theta

    # get parameters from dictionary
    unix_tvec          = modelparam["unix_tvec"]
    fitting_period_ind = modelparam["fitting_period_ind"]
    unix_tSS           = modelparam["unix_tSS"]
    unix_tPF           = modelparam["unix_tPF"]

    tmin1 = 10**log10tmin1
    tmax1 = 10**log10tmax1
    tmin2 = 10**log10tmin2
    tmax2 = 10**log10tmax2

    GWL_trim     = compute_GWLchange(a_precip, **modelparam)
    T_shift_trim = compute_tempshift(t_shiftdays, smooth_winlen = 6, **modelparam)

    # Coseismic change
    #---Load c compiled library for the integration of healing model---#
    lib_int = ctypes.CDLL(os.path.abspath('./LowLevel_callback_healing_distributed/healing_int.so'))
    lib_int.f.restype = ctypes.c_double
    lib_int.f.argtypes = (ctypes.c_int, ctypes.POINTER(ctypes.c_double), ctypes.c_void_p)
    #-------------------------------------------------------------------#
    y_healing = compute_y_healing(unix_tvec[fitting_period_ind], S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int)

    # Construct model
    model = a0 + p1 * GWL_trim + p2 * T_shift_trim + y_healing
    #---------------------#

    if all:
        y_healing_SS, y_healing_PF = compute_y_healing_factor(unix_tvec[fitting_period_ind], S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int)
        return (model, p1 * GWL_trim, p2 * T_shift_trim, y_healing_SS, y_healing_PF)
    else:
        return model

def model_wlin(theta, all=False, **modelparam):
    """
    dv/v base model with linear trend term.
    """

    assert modelparam["ndim"] == len(theta)
    a0, p1, a_precip, p2, t_shiftdays, S1, log10tmin1, log10tmax1, S2, log10tmin2, log10tmax2, b_lin, log_f = theta

    # get parameters from dictionary
    unix_tvec          = modelparam["unix_tvec"]
    fitting_period_ind = modelparam["fitting_period_ind"]
    unix_tSS           = modelparam["unix_tSS"]
    unix_tPF           = modelparam["unix_tPF"]

    tmin1 = 10**log10tmin1
    tmax1 = 10**log10tmax1
    tmin2 = 10**log10tmin2
    tmax2 = 10**log10tmax2

    GWL_trim     = compute_GWLchange(a_precip, **modelparam)
    T_shift_trim = compute_tempshift(t_shiftdays, smooth_winlen = 6, **modelparam)

    # Coseismic change
    #---Load c compiled library for the integration of healing model---#
    lib_int = ctypes.CDLL(os.path.abspath('./LowLevel_callback_healing_distributed/healing_int.so'))
    lib_int.f.restype = ctypes.c_double
    lib_int.f.argtypes = (ctypes.c_int, ctypes.POINTER(ctypes.c_double), ctypes.c_void_p)
    #-------------------------------------------------------------------#
    y_healing = compute_y_healing(unix_tvec[fitting_period_ind], S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int)
    lintrend = compute_lineartrend(unix_tvec[fitting_period_ind], b_lin)

    # Construct model
    model = a0 + p1 * GWL_trim + p2 * T_shift_trim + y_healing + lintrend
    #---------------------#

    if all:
        y_healing_SS, y_healing_PF = compute_y_healing_factor(unix_tvec[fitting_period_ind], S1, S2, tmin1, tmax1, tmin2, tmax2, unix_tSS, unix_tPF, lib_int)
        return (model, p1 * GWL_trim, p2 * T_shift_trim, y_healing_SS, y_healing_PF, lintrend)
    else:
        return model

#---Log probabilities---#

# def log_likelihood(theta, unix_tvec, y_trim, yerr_trim, precip, temperature, fitting_period_ind, unix_tSS, unix_tPF):
def log_likelihood(theta, **modelparam):
    """
    Note: precip and temperature should have same length and timing with unix_tvec
    """
    #parse parameters
    dvv_data_trim  =modelparam["dvv_data_trim"]
    err_data_trim  =modelparam["err_data_trim"]

    modelcase = modelparam["modelcase"]
    keys      = modelparam["keys"]

    log_f = theta[keys.index("log_f")]

    # print(modelcase, keys)
    # print(keys)
    # print(type(theta))
    # print(list(theta))
    #

    # a0, p1, a_precip, p2, t_shiftdays, S1, log10tm1, S2, log10tm2, log_f = theta

    #---Select model---#

    if modelcase.lower() == "base":
        model = model_base(theta, all=False, **modelparam)
    elif modelcase.lower() == "wlin":
        model = model_wlin(theta, all=False, **modelparam)

    # sigma2 = yerr_trim ** 2 + model ** 2 * np.exp(2 * log_f)
    sigma2 = err_data_trim ** 2 + np.exp(2 * log_f) # 2022.2.21 Applying constant over/under estimation in error

    return -0.5 * np.nansum((dvv_data_trim - model) ** 2 / sigma2 + np.log(sigma2)) # 2pi is ignored

# assign boundary of parammeters as prior probability
def log_prior(theta, **modelparam):
    # print(theta)
    # print(modelparam)
    keys      = modelparam["keys"]

    # find S2 for the boundary
    S2 = theta[keys.index("S2")]

    #2. evaluate the boundaries
    for i, key in enumerate(keys):
        # print(key, val)
        vmin, vmax = modelparam[key][1]
        val = theta[i]

        if key == "S1": # special case for the boundary
            # apply boundaries associated with the magnitude of S1
            if val < vmin or vmax * S2 < val:
                return -np.inf

        else:
            if val < vmin or vmax < val:
                return -np.inf
    # if all the trial parameters are within the boundaries, return 0.
    return 0

def log_probability(theta, **modelparam):
    time.process_time()
    # print(type(modelparam))
    lp = log_prior(theta, **modelparam)
    # print(lp)
    if not np.isfinite(lp):
        return -np.inf
    return lp + log_likelihood(theta, **modelparam)
