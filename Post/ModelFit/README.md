# Modeling dv/v

Here we describe the work flow of the post processing of dv/v measurements.


## 0. Download the data sheet of dv/v
The dv/v estimation from the stacked correlation functions is gathered in the csv data sheet. We computed the datasets from 2002/01 to 2022/06 using the stretching and MWCS methods. You can download them from [UW dasway](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_uwbackup_2010-2022.tar.gz) or [Zenodo repository](). Please locate the csv files in `Post/ModelFit/data`.

## 1. Preprocess dv/v traces
`modelfit_01_preprocess_dvv_v01.ipynb` performs the channel weighting of the station pairs and store it into `processed_data/dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching/mwcs.csv_1.2-2.0.h5`. Here we apply the threhold of `CC>0.7` or `err>0.02%` for the case with stretching and mwcs, respectively, on the dv/v associated with the station-channel pairs. Select the method and frequency band and run the notebook. We compute the fraction of dv/v data to the length of time vector over 20 years, but the threshold is applied in the next step.

## 2. Qualify the channel-weighted dv/v traces
`modelfit_02_qualify_dvv_v01.ipynb` applies the threshold of the fraction of the valid dv/v measurement to the study period, indicated as `data_contents_min = 0.7`.  We also remove the outliers with the magnitude more than `0.3%` of the dv/v as this magnitude would be unrealistic in the change of structure, which degrades the model fitting. This notebook outputs `02dvvanderr_formodelfit_chanweighted_dvvtraces_chanweighted_monitoring_stats_uwbackup_2010-2022_stretching/mwcs.csv_0.9-1.2.h5`

## 3.  Process the time history of precipitation and temperature
The raw data of the temperature can be donwloaded from https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USR0000CPAR/detail. We also downloaded monthly precipitation data from the Wildland Fire Remote Automated Weather Stations (RAWS) between 2001-2022 at Parkfield. https://raws.dri.edu/cgi-bin/rawMAIN.pl?caCPAR. We applied the low-pass filter and downsampled the temperature time series to synchronize with the dv/v time history. We also resampled the monthly precipitation time series with linear interpolation. Note that we need to rescale the total precipitation when resampling the precipitation, whereas we didn't apply it as we only focus on the trend of precipitation, not the absolute values. We thus conducted only the linear interpolation to the time series of precipitation for sake of the synchronization. See the detain in the notebook.

The output ot `data/interped_tempandprecip.csv` and `interped_tempandprecip_longterm.csv` are used for the model fitting.

## 4. Model fitting with original dv/v to precipitation and temperature.


## 5.


## 6.


## 7.




### 3.1 Fit precip and temperature and obtain coefficient
We perform model fitting with julia to estimate best fitting parameter on precip and temperature model. Save parameters into csv.

$$ y_model = $$


### 3.2 Reconstruct models and subtract from original dv/v
In python notebook, reconstruct the models associated with GWL and temperature using coefficients, and subtract from dv/v. It is used in next step to estimate coseismic drop of dv/v.

### 3.3 Fit logarithmically healing model of coseimsic velocity drop
We again estimate coseimsic drop using Julia and dv/v where GWL and temperature are subtracted. Save coefficients to csv.

## 4. Process with subtraction
The models are subtracted from dv/v, and focus on the residuals. Save each station-channel pairs into csv.

## 5. Post process result.
Plot all with mean and std.

## 1.7 applying MCMC modelfit
To show multimodality of parameter fitting, we apply MCMC algorithm to search parameters.


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
