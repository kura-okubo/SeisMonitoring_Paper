#!/usr/bin/env python
# coding: utf-8

# # MCMC model fitting
# 2021.11.24 Kurama Okubo
#
# 2022.1.18 update to speed up iteration and clean up the notebook.
#
# 2022.10.5 update AIC and model selection
# 2023.4.3 update to conduct all the model cases

# This notebook conduct MCMC model fitting to estimate model parameters as well as showning the multimodality.

import datetime
import os
import time

os.environ["OMP_NUM_THREADS"] = "4"

import matplotlib.pyplot as plt

import numpy as np
import pandas as pd
import h5py
import pickle

from tqdm import tqdm


# For the speed up of integral with Low level calling functoin
import ctypes
from scipy import LowLevelCallable

import emcee # MCMC sampler
# import corner

# import functions for MCMC
from MCMC_func import *

from multiprocessing import Pool, cpu_count

#plt.rcParams["font.family"] = "Arial"
plt.rcParams["font.size"] = 12
os.environ['TZ'] = 'GMT' # change time zone to avoid confusion in unix_tvec conversion

ncpu = cpu_count()
print("{0} CPUs".format(ncpu))

if __name__ == '__main__':

    #---set the file path of your case study list---#
    root = "../processed_data/"
    h5_stats_list = [
                    root+"02dvvanderr_formodelfit_chanweighted_dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching.csv_0.9-1.2.h5",
                    root+"02dvvanderr_formodelfit_chanweighted_dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_mwcs.csv_0.9-1.2.h5"]

    # fitting start and end time
    starttime = datetime.datetime(2002, 1, 1)
    endtime = datetime.datetime(2022, 6, 1)

    # parameters for stacking; identical to the input file of the stacking
    cc_time_unit=86400 # short-stacking time unit
    averagestack_factor=30 # length of time bin to compute mean and std
    averagestack_step=15
    datefreq = '%dD'%(averagestack_step*cc_time_unit/86400)

    # set initial value and boundaries of the model parameters
    # format is: (initial value, [vmin, vmax])
    # offset, scale of GWL, delay in GWL, scale of Temp, shift of temp in days, scale in coseimic change, healing duration for SS and PF and linear trend.
    modelparam = {
                "a0"            : (0.0, [-1.0, 1.0]), # offset
                "p1"            : (-0.005, [-np.inf, 0.0]), # scale of GWL bounded as negative considering previous studies
                "a_{precip}"      : (1e-2, [0, 1.0]), # delay in GWL [1/day]
                "p2"            : (0.01, [-np.inf, np.inf]), # scale of Temp
                "t_{shiftdays}"   : (7, [0, 90]), #(7, [0, 120]), # shift of temp in days
                "S1"            : (0.03, [0.0, 0.5]), # scale in coseimic change at SS NOTE: the vmax is assigned as the factor with S1
                "log10tmin1"    : (0, [-1, 7.98]), # healing tmin duration
                "log10tmax1"    : (np.log10(1e8), [7.5, 12]), # healing tmax duration # ranging from 1 year to 30000 years
                "S2"            : (0.08, [0.0, 1.0]), # scale in coseimic change at PF
                "log10tmin2"    : (0, [-1, 7.98]), # healing tmin duration
                "log10tmax2"    : (np.log10(2.67e8), [7.5, 12]), # healing tmax duration # ranging from 1 year to 30000 years
                "b_{lin}"         : (0.0, [-np.inf, np.inf]), # slope of linear trend
                "logf"         : (0.0, [-10, 10]), # magnitude of uncertainity
                }


    modelparam["fixparam01"] = True # true if fixing some model parameters

    # select the number of iteration during the MCMC inversion
    modelparam["nsteps"] = 20000 #10000#30000

    # MCMC parameters
    modelparam["nwalkers"] = 32 # number of chains

    output_imgdir = "../figure/MCMC_modelfit"
    output_imgdir_debug = "../figure/MCMC_modelfit_dvvtrace"
    output_datadir = "../processed_data/MCMC_sampler_{}".format(modelparam["nsteps"])

    # set random seed to fix the initial chains
    np.random.seed(seed=20221108)
    #-------------------------------------------#

    if not os.path.exists(output_imgdir):
        os.makedirs(output_imgdir)

    if not os.path.exists(output_imgdir_debug):
        os.makedirs(output_imgdir_debug)

    if not os.path.exists(output_datadir):
        os.makedirs(output_datadir)

    # select the file to process
    for h5_id in [0, 1]:
        # model case
        for modelcase in ["base", "wlin"]:
            modelparam["modelcase"] = modelcase

            #---Read keys from filename---#
            casename = os.path.basename(h5_stats_list[h5_id].split('.h5')[0])
            freqband = h5_stats_list[h5_id].split('.h5')[0].split('_')[-1]
            dvvmethod = casename.split('.csv')[0].split('_')[-1]

            print(f"start processing {casename} {modelcase}")

            # If the model parameter is fixed and "fixparam01" is true, 
            # the MCMC search is not applied on the parameters.
            # The initial value is disabled, but the fixed value needs to be
            # within the range described in the modelparam. 
            if dvvmethod=="stretching":
                modelparam["a_{precip}_fixed"] = 0.02426
                modelparam["log10tmin1_fixed"] = 6.293
                modelparam["log10tmin2_fixed"] = 6.996

            elif dvvmethod=="mwcs":
                modelparam["a_{precip}_fixed"] = 0.03888
                modelparam["log10tmin1_fixed"] = 4.903
                modelparam["log10tmin2_fixed"] = 6.993


            #---Read csv containing channel-weighted dvv and err---#
            fi = h5py.File(h5_stats_list[h5_id], "r")

            #---Compute unix time vector---#
            uniform_tvec_unix = np.array(fi['uniform_tvec'])
            uniform_tvec = np.array([datetime.datetime.utcfromtimestamp(x) for x in uniform_tvec_unix])
            unix_tvec = np.array([x.timestamp() for x in uniform_tvec])

            modelparam["averagestack_step"] = averagestack_step
            modelparam["uniform_tvec"] = uniform_tvec
            modelparam["unix_tvec"] = unix_tvec
            #---Trim the time series from the starttime to the endtime---#
            fitting_period_ind = np.where((uniform_tvec >= starttime) & (uniform_tvec <= endtime))[0]
            # print(np.where((uniform_tvec >= starttime) & (uniform_tvec <= endtime)))
            modelparam["fitting_period_ind"] = fitting_period_ind

            #---Compute time at San Simeon and Parkfield EQ for healing model---#
            tSS = datetime.datetime(2003, 12, 22) # time for San Simeon
            tPF = datetime.datetime(2004, 9, 28) # time for Park field
            unix_tSS = (tSS - pd.Timestamp("1970-01-01")) // pd.Timedelta('1s') # origin of time
            unix_tPF = (tPF - pd.Timestamp("1970-01-01")) // pd.Timedelta('1s') # origin of time

            modelparam["unix_tSS"]   = unix_tSS
            modelparam["unix_tPF"]   = unix_tPF

            #---Read temperature and precipitation data at Parkfield---#
            df_tandp= pd.read_csv("../data/interped_tempandprecip_longterm.csv", header=0, sep = ',')
            df_tandp = df_tandp.set_index("t")
            df_tandp.index = pd.to_datetime(df_tandp.index)

            # Synchronize the long-period temperature and precipitation
            df_tandp_synchronized = df_tandp[(df_tandp.index>starttime) & (df_tandp.index<endtime)]

            # store time history of trimmed precipitation and temperature
            modelparam["precip"] = df_tandp_synchronized.precip
            modelparam["CAVG"]   = df_tandp_synchronized.CAVG

            # 2nd way to check the consistency of time vector
#             st_center = (averagestack_factor*cc_time_unit/86400)/2
#             date_range_st = starttime + datetime.timedelta(days=st_center) # day
#             uniformdates = pd.date_range(start=date_range_st, end=endtime, freq=datefreq)
#             uniform_tvec2 = uniformdates.date
#             print(uniform_tvec2)
#             uniform_tvec3 = [x.date() for x in uniform_tvec]

#             print(uniform_tvec)
#             print(uniform_tvec2)
#             print(uniform_tvec3)

#             for i in range(len(uniform_tvec2)):
#                 assert uniform_tvec3[i] == uniform_tvec2[i]

            #---Generate the initial model parameters with chains---#

            pos, ndim, keys = get_init_param(**modelparam)
            modelparam["keys"] = keys

            if modelparam["fixparam01"]:
                
                pos_fixed = np.delete(pos, [keys.index("a_{precip}"), keys.index("log10tmin1"), 
                    keys.index("log10tmin2")], 1)
                # print(pos_fixed)
                modelparam["pos"] = pos_fixed
                modelparam["ndim"] = ndim - 3 # minus the a_{precip}, tmin1 and tmin2
            
            else:
                modelparam["pos"] = pos
                modelparam["ndim"] = ndim

            #---Extract station pairs used for model fitting---#
            stationpairs = list(fi['dvv'].keys())
            print(stationpairs)
            #------------------------------------------------------#

            # select station ids for debug
            stationids = range(len(stationpairs))
            # stationids = [stationpairs.index("BP.EADB-BP.VCAB")]
            # print(stationids)
            # stationids = [40, 13, 26, 32]
            # stationids = range(37,len(stationpairs))

            # for stationpair in tqdm(stationpairs):

            for stationpair in tqdm([stationpairs[i] for i in stationids]):

                print("start processing :"+stationpair)

                # search file and skip if it exists.
                foname = output_datadir+"/MCMC_sampler_%s_%s_%s_%s.pickle"%(stationpair, freqband, modelparam["modelcase"], dvvmethod)

                if os.path.exists(foname):
                    print(os.path.basename(foname) + "exists. Skipping.")
                    continue;

                dvv_data = np.array(fi["dvv/{}/dvv".format(stationpair)])
                err_data = np.array(fi["dvv/{}/err".format(stationpair)])

                #---plot dv/v for the debug---#
                fig, ax = plt.subplots(1, 1, figsize=(8,3))
                ax.errorbar(uniform_tvec, dvv_data, yerr = err_data, capsize=3, ls="-", c = "r", ecolor='black')
                plt.tight_layout()
                plt.savefig(output_imgdir_debug+"/MCMCdvv_%s_%s_%s.png"%(stationpair, freqband, modelparam["modelcase"]), format="png", dpi=150)
                plt.close()
                plt.clf()

                #---Trim the dvv and err time history---#
                modelparam["dvv_data_trim"] =  dvv_data[fitting_period_ind]
                modelparam["err_data_trim"] =  err_data[fitting_period_ind]

                with Pool() as pool:
                    sampler = emcee.EnsembleSampler(
                                    modelparam["nwalkers"], modelparam["ndim"], log_probability,
                                    # moves=[(emcee.moves.StretchMove(), 0.5),
                                    #          (emcee.moves.DESnookerMove(), 0.5),], # Reference of Move: https://github.com/lermert/cdmx_dvv/blob/main/m.py
                                    moves=emcee.moves.StretchMove(),
                                    kwargs=(modelparam),
                                    pool=pool)

                    start = time.time()
                    sampler.run_mcmc(modelparam["pos"], modelparam["nsteps"], progress=True)
                    end = time.time()
                    multi_time = end - start
                    print("Multiprocessing took {0:.1f} seconds".format(multi_time))

                # Save the current state.
                with open(foname, "wb") as f:
                    pickle.dump(sampler, f)
                    pickle.dump(modelparam, f)
