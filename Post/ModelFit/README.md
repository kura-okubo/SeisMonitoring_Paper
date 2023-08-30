# Work flow of modeling dv/v

Here we describe the work flow of the post processing of dv/v measurements.


## 0. Download the data sheet of dv/v
The dv/v estimation from the stacked correlation functions is gathered in the csv data sheet. We computed the datasets from 2002/01 to 2022/06 using the stretching and MWCS methods. You can download them from [UW dasway](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_uwbackup_2010-2022.tar.gz) or [Zenodo repository](). Please locate the csv files in `Post/ModelFit/data`.

## 1. Preprocess dv/v traces
`modelfit_01_preprocess_dvv_v01.ipynb` performs the channel weighting of the station pairs and store it into `processed_data/dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching/mwcs.csv_1.2-2.0.h5`. Here we apply the threhold of `CC>0.7` or `err>0.02%` for the case with stretching and mwcs, respectively, on the dv/v associated with the station-channel pairs. Select the method and frequency band and run the notebook. We compute the fraction of dv/v data to the length of time vector over 20 years, but the threshold is applied in the next step.

## 2. Qualify the channel-weighted dv/v traces
`modelfit_02_qualify_dvv_v01.ipynb` applies the threshold of the fraction of the valid dv/v measurement to the study period, indicated as `data_contents_min = 0.7`.  We also remove the outliers with the magnitude more than `0.3%` of the dv/v as this magnitude would be unrealistic in the change of structure, which degrades the model fitting. This notebook outputs `02dvvanderr_formodelfit_chanweighted_dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching/mwcs.csv_0.9-1.2.h5`

## 3.  Process the time history of precipitation and temperature
The raw data of the temperature can be donwloaded from https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USR0000CPAR/detail. We also downloaded monthly precipitation data from the Wildland Fire Remote Automated Weather Stations (RAWS) between 2001-2022 at Parkfield. https://raws.dri.edu/cgi-bin/rawMAIN.pl?caCPAR. We applied the low-pass filter and downsampled the temperature time series to synchronize with the dv/v time history. We also resampled the monthly precipitation time series with linear interpolation. Note that we need to rescale the total precipitation when resampling the precipitation, whereas we didn't apply it as we only focus on the trend of precipitation, not the absolute values. We thus conducted only the linear interpolation to the time series of precipitation for sake of the synchronization. See the detain in the notebook.

The output of `data/interped_tempandprecip.csv` and `interped_tempandprecip_longterm.csv` are used for the model fitting.

## 4. Model fitting using MCMC.
We perform the MCMC parameter search by minimizing the residual of the observed and the modeled dv/v time histories. Run `python modelfit_04_MCMC_v05_fixmodelparam_niedws_t0-90days.py` to conduct the MCMC iteration in parallel. We used [emcee](https://emcee.readthedocs.io/en/stable/) to conduct the MCMC parameter sampling. We also used [multiprocessing](https://docs.python.org/3/library/multiprocessing.html) to parallelize the iteration. You don't need to run with `mpirun`. You can assign the number of cores in the script by e.g. `os.environ["OMP_NUM_THREADS"] = "4"`.

To speed up the integration of logarithmically healing model, we implement the [Low-level callback function](https://docs.scipy.org/doc/scipy/tutorial/integrate.html#faster-integration-using-low-level-callback-functions) in scipy. Before running the MCMC, you need to compile the shared library by `gcc -shared -o healing_int.so healing_int.c` in `code/LowLevel_callback_healing_distributed`.

The output of sampler containing the result of MCMC parameter sampling is stored in `processed_data/MCMC_sampler_{nstep}/`. You can download the result of the model fitting for all the station pairs from the dasway: [MCMC_sampler_20000_v2_master.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_master.tar.gz) (3.5GB).

## 5. Collect the result of MCMC sampler and the dv/v
After running the MCMC, we collect the result of parameter sampling with the dv/v time history by running `modelfit_05_MCMC_modelfit.ipynb`. The input samplar file in pickle format needs to be located in e.g. `processed_data/MCMC_sampler_20000_v2_master`. This outputs the figures associated with the sampling process and the comparison between the model and data of dv/v, and the intermediate file in `modelparam_data`, used for the statistics of model parameter and the plotting. You need to run all the cases such as stretching and MWCS with `base` and `wlin` model to conduct the following steps.

## 6. Compile the maximum likelihood model parameters
`modelfit_06_MCMC_computemodelstats.ipynb` gather the maximum likelihood model parameters used for the statistical analysis. Select the `dvvmethod` and `modelcase` for all the cases associated with stretching/MWCS and base/wlin.

## 7. Plot the statistical analysis of model parameters
`modelfit_07_MCMC_plotstats.ipynb` plot the statistical analysis of the maximum likelihood model parameters. Before running this notebook, you need to run `Maps/BPnetwork_Faultdist/compute_faultnormaldistance/code/BPnetwork_computeFaultdist.ipynb` to compute the fault-normal distance of the seismic stations. The random seed is preset to fix the jitter plots.


---
# Plot the dv/v figures
## i. Reshape the raw dv/v data sheet
We reshape the dv/v data sheet using `pivot` function and save to the new csv, which is used to plot the overview of the dv/v time series. Run `plotfigure_convert_dvvdata.ipynb`.

## ii. Plot the overview of dv/v time series.
`plotfigure_plotdvvpsd.ipynb` plots the overview dv/v time series as follows:

- psudo-Probability density of the dv/v measurement for all of the station-channel pairs
- Counts of the station-channel pairs per time bins
- dv/v with different components
- dv/v with different frequency bands
- Comparison before and after the channel weighting

Some of the figures are used in the main text.

## iii. Plot the scatter matrix and model fitting of dv/v.
`Post/ModelFit/code/plotfigure_MCMCscattermatrix_stretching/mwcs.ipynb` generates the scatter matrix of MCMC parameter sampling and dump the data of modeled dv/v. You need to run up to step 2 to obtain the `02dvvanderr_formodelfit_chanweighted_dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching/mwcs.csv_0.9-1.2.h5` and download the MCMC sampler of `MCMC_sampler_20000_v2_master.tar.gz`. Then, `plotfigure_MCMCdvvmodelfit.ipynb` plots the comparison of base and wlin models.

## iv. Plot the comparison of the best model and data of dv/v
`plotfigure_alldvvmodelfit.ipynb` generates the comparison between the maximum likelihood models and the observed dv/v for all the station pairs. We also plot the dv/v sorted by the fault-normal distance to investigate the change in `tmax` as a function of the distance.
