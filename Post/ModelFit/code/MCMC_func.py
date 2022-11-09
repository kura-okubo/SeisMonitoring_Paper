import datetime
import os
import time

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.dates as dates
import matplotlib.dates as mdates
# get_ipython().run_line_magic('matplotlib', 'inline')

import numpy as np
import pandas as pd
import h5py
import pickle

import shutil
from tqdm import tqdm

from scipy.optimize import curve_fit
from scipy.integrate import quad

# For the speed up of integral with Low level calling functoin
import ctypes
from scipy import LowLevelCallable

import matplotlib as mpl

import emcee # MCMC sampler
import corner

from multiprocessing import Pool, cpu_count


def logheal_llc(ts, S, taumax, lib_int):
    # using Low-level caling function
    taumin = 0.1 # fix taumin so that healing starts just after incident    
    c = ctypes.c_double(ts) # time t as void * userdata
    user_data = ctypes.cast(ctypes.pointer(c), ctypes.c_void_p)
    int1_llc = LowLevelCallable(lib_int.f, user_data) # in this way, only void* is available as argument
    
    return -S*quad(int1_llc, taumin, taumax,epsabs = 1e-3, epsrel=1e-3)[0] # this tolerance archieves our requirement in accuracy.

# coseismic healing with cumtrapz
def y_heal_llc(t, S, taumax, unix_tEV, lib_int):
    if t < unix_tEV:
        return 0
    else:
        # compute logheal model
        return logheal_llc(t-unix_tEV, S, taumax, lib_int)

def compute_y_healing(tvec, S1, S2, tm1, tm2, unix_tSS, unix_tPF, lib_int):
    #return list(map(lambda t: y1_llc(t, S1, tm1) + y2_llc(t, S2, tm2), tvec))
    return [y_heal_llc(t, S1, tm1, unix_tSS, lib_int) + y_heal_llc(t, S2, tm2, unix_tPF, lib_int) for t in tvec ]

def compute_y_healing_factor(tvec, S1, S2, tm1, tm2, unix_tSS, unix_tPF, lib_int):
    #return list(map(lambda t: y1_llc(t, S1, tm1) + y2_llc(t, S2, tm2), tvec))
    return [[y_heal_llc(t, S1, tm1, unix_tSS, lib_int) for t in tvec ],
            [y_heal_llc(t, S2, tm2, unix_tPF, lib_int) for t in tvec]]

#---model the change of ground water level---#
def SSW06(precip, phi, a): # originally developped in Julia by Tim Clements
    Nprecip = len(precip)
    expij = [np.exp(-a*x) for x in range(Nprecip)]
    GWL = np.convolve(expij, precip - np.mean(precip), mode='full')[:Nprecip] / phi
    return GWL
#-----------------------#

def log_likelihood(theta, unix_tvec, y_trim, yerr_trim, precip, temperature, fitting_period_ind, unix_tSS, unix_tPF):
    """
    Note: precip and temperature should have same length and timing with unix_tvec
    """    
    #parse parameters
    a0, p1, a_precip, p2, t_shiftdays, S1, log10tm1, S2, log10tm2, log_f = theta
    
    # tm1, tm2 is in log, so put back to linear scale
    tm1 = 10**log10tm1
    tm2 = 10**log10tm2

    #---Make model---#

    # GWL change
    phi = 0.05   # porosity
    GWL = SSW06(np.array(precip)/1e3, phi, a_precip)
    GWL = GWL - np.mean(GWL)
    GWL_trim = GWL[fitting_period_ind]
    
    # Shifted temperature
    smooth_winlen = 6 # smoothing with 6 * 15 days = 3 months
    smooth_temp = np.convolve(temperature, np.ones(smooth_winlen)/smooth_winlen, mode='same')
    T_shift = np.interp(unix_tvec - t_shiftdays*86400, unix_tvec, smooth_temp)
    T_shift_trim = T_shift[fitting_period_ind]
    
    # Coseismic change
    lib_int = ctypes.CDLL(os.path.abspath('./LowLevel_callback_healing_distributed/healing_int.so'))
    lib_int.f.restype = ctypes.c_double
    lib_int.f.argtypes = (ctypes.c_int, ctypes.POINTER(ctypes.c_double), ctypes.c_void_p)
    
    
    y_healing = compute_y_healing(unix_tvec[fitting_period_ind], S1, S2, tm1, tm2, unix_tSS, unix_tPF, lib_int) 
    # Construct model
    model = a0 + p1 * GWL_trim + p2 * T_shift_trim + y_healing
    #---------------------#

    # sigma2 = yerr_trim ** 2 + model ** 2 * np.exp(2 * log_f)
    sigma2 = yerr_trim ** 2 + np.exp(2 * log_f) # 2022.2.21 Applying constant over/under estimation in error


    return -0.5 * np.nansum((y_trim - model) ** 2 / sigma2 + np.log(sigma2)) # 2pi is ignored

# assign boundary of parammeters as prior probability
def log_prior(theta):
    
    a0, p1, a_precip, p2, t_shiftdays, S1, tm1, S2, tm2, log_f = theta

    if (
        -1.0 < a0 < 1.0 and
        -np.inf < p1 < np.inf and
        0 < a_precip < 0.1 and
        -np.inf < p2 < np.inf and
        0 <= t_shiftdays < 180 and     
        # 0.0 < S1 < 0.1 and
        # 0.0 < S1 < 0.01 and
        0.0 < S1 < 0.05*S2, 
        0.0 < tm1 < 10 and
        0.0 < S2 < 0.1 and
        0.0 < tm2 < 10 and
        -10.0 < log_f < 10.0
    ):
        return 0.0
    return -np.inf


def log_probability(theta, unix_tvec, y, yerr, precip, temperature, fitting_period_ind, unix_tSS, unix_tPF):
    time.process_time()
    lp = log_prior(theta)
    if not np.isfinite(lp):
        return -np.inf
    return lp + log_likelihood(theta, unix_tvec, y, yerr, precip, temperature, fitting_period_ind, unix_tSS, unix_tPF)
