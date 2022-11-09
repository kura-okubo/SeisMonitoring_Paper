#!/usr/bin/env python
# coding: utf-8

# # MCMC model fitting
# 2021.11.24 Kurama Okubo
# 
# 2022.1.18 update to speed up iteration and clean up the notebook.
# 
# 2022.10.5 update AIC and model selection

# This notebook conduct MCMC model fitting to estimate model parameters as well as showning the multimodality.

import datetime
import os
import time

os.environ["OMP_NUM_THREADS"] = "8"

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.dates as dates
import matplotlib.dates as mdates

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

plt.rcParams["font.family"] = "Arial"
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


    vlines = [datetime.datetime(2003, 12, 22), datetime.datetime(2004, 9, 28)] 

    h5_id = 1

    nsteps = 5000#30000 # number of iteration

    output_imgdir = "../figure/MCMC_modelfit"
    output_imgdir_debug = "../figure/MCMC_modelfit_dvvtrace"
    output_datadir = "../processed_data/MCMC_sampler_{}".format(nsteps)

    modelcase = "nonlin"
    #-------------------------------------------#

    if modelcase == "nonlin":
        from MCMC_func import *

    elif modelcase == "wlin":
        from MCMC_func_wlintrend import *


    if not os.path.exists(output_imgdir):
        os.makedirs(output_imgdir)    

    if not os.path.exists(output_imgdir_debug):
        os.makedirs(output_imgdir_debug)
        
    if not os.path.exists(output_datadir):
        os.makedirs(output_datadir)

    #---Read keys from filename---#
    casename = os.path.basename(h5_stats_list[h5_id].split('.h5')[0])
    freqband = h5_stats_list[h5_id].split('.h5')[0].split('_')[-1]
    dvvmethod = casename.split('.csv')[0].split('_')[-1]

    #---Read csv containing channel-weighted dvv and err---#
    fi = h5py.File(h5_stats_list[h5_id], "r")


    #---Compute unix time vector---#
    uniform_tvec_unix = np.array(fi['uniform_tvec'])
    uniform_tvec = np.array([datetime.datetime.utcfromtimestamp(x) for x in uniform_tvec_unix])
    unix_tvec = np.array([x.timestamp() for x in uniform_tvec])

    #---Compute time at San Simeon and Parkfield EQ for healing model---#
    tSS = datetime.datetime(2003, 12, 22) # time for San Simeon
    tPF = datetime.datetime(2004, 9, 28) # time for Park field
    unix_tSS = (tSS - pd.Timestamp("1970-01-01")) // pd.Timedelta('1s') # origin of time
    unix_tPF = (tPF - pd.Timestamp("1970-01-01")) // pd.Timedelta('1s') # origin of time

    #---Read temperature and precipitation data at Parkfield---#
    df_tandp= pd.read_csv("../data/interped_tempandprecip_longterm.csv", header=0, sep = ',')
    df_tandp = df_tandp.set_index("t")
    df_tandp.index = pd.to_datetime(df_tandp.index)

    # # 2nd way
    # st_center = (averagestack_factor*cc_time_unit/86400)/2
    # date_range_st = starttime + datetime.timedelta(days=st_center) # day
    # uniformdates = pd.date_range(start=date_range_st, end=endtime, freq=datefreq)
    # uniform_tvec = uniformdates.date
    # print(uniform_tvec)
    # uniform_tvec3 = [x.date() for x in uniform_tvec1]

    # print(uniform_tvec1)
    # print(uniform_tvec2)
    # print(uniform_tvec3)

    # for i in range(len(uniform_tvec2)):
    #     assert uniform_tvec3[i] == uniform_tvec2[i]

    #---Extract station pairs used for model fitting---#
    stationpairs = list(fi['dvv'].keys())
    print(stationpairs)
    #------------------------------------------------------#
    
    # select station ids
    stationids = [40]
    


    # for stationpair in tqdm(stationpairs): 
    for stationpair in tqdm([stationpairs[i] for i in stationids]): 

        print("start processing :"+stationpair)

        # search file and skip if it exists.
        foname = output_datadir+"/MCMC_sampler_%s_%s_%s.pickle"%(stationpair, freqband, modelcase)

        if os.path.exists(foname):
            print(os.path.basename(foname) + "exists. Skipping.")
            continue;

        dvv_data = np.array(fi["dvv/{}/dvv".format(stationpair)])
        err_data = np.array(fi["dvv/{}/err".format(stationpair)])

        fig, ax = plt.subplots(1, 1, figsize=(8,3))
        ax.errorbar(uniform_tvec, dvv_data, yerr = err_data, capsize=3, ls="-", c = "r", ecolor='black')
        plt.tight_layout()
        plt.savefig(output_imgdir_debug+"/MCMCdvv_%s_%s_%s.png"%(stationpair, freqband, modelcase), format="png", dpi=150)
        plt.close()
        plt.clf()

        # Reference: https://emcee.readthedocs.io/en/stable/tutorials/line/
        fitting_period_ind = np.where((uniform_tvec >= starttime) & (uniform_tvec <= endtime))[0]

        dvv_data_trim =  dvv_data[fitting_period_ind]
        err_data_trim =  err_data[fitting_period_ind]

        # Synchronize the long-period temperature and precipitation
        df_tandp_synchronized = df_tandp[(df_tandp.index>starttime) & (df_tandp.index<endtime)]

        # offset, scale of GWL, delay in GWL, scale of Temp, shift of temp in days, scale in coseimic change, healing duration for SS and PF.
        np.random.seed(seed=20221108)
        
        if modelcase=="nonlin":
            pos = [0.0, 0.01, 1e-3, 0.01, 1, 0.005, np.log10(1e7), 0.03, np.log10(2.67e8), 0.1] + 1e-4 * np.random.randn(32, 10)
        elif modelcase=="wlin":
            pos = [0.0, 0.01, 1e-3, 0.01, 1, 0.03, np.log10(1e7), 0.03, np.log10(2.67e8), 0.0, 0.1] + 1e-4 * np.random.randn(32, 11)
  
        nwalkers, ndim = pos.shape

        # sampler = emcee.EnsembleSampler(
        #     nwalkers, ndim, log_probability, args=(unix_tvec, dvv_data_trim, err_data_trim, df_tandp_synchronized.precip, df_tandp_synchronized.CAVG)
        # )
        # sampler.run_mcmc(pos, nsteps, progress=True);

        # with Pool(processes=1) as pool:
        with Pool() as pool:
            sampler = emcee.EnsembleSampler(
                            nwalkers, ndim, log_probability, 
                            # moves=[(emcee.moves.DEMove(), 0.8),
                            #         (emcee.moves.DESnookerMove(), 0.2),],
                            args=(unix_tvec, dvv_data_trim, err_data_trim, df_tandp_synchronized.precip,
                                   df_tandp_synchronized.CAVG, fitting_period_ind, unix_tSS, unix_tPF), 
                            pool=pool) # Reference: https://github.com/lermert/cdmx_dvv/blob/main/m.py

            start = time.time()
            sampler.run_mcmc(pos, nsteps, progress=True)
            end = time.time()
            multi_time = end - start
            print("Multiprocessing took {0:.1f} seconds".format(multi_time))
                
        # Save the current state.
        with open(foname, "wb") as f:
            pickle.dump(sampler, f)





