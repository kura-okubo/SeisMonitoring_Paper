# Note on modeling dv/v
2023/3/18 Kurama Okubo

This notebook contains how we process data from raw csv files.

## Raw csv files
They are in `Okuboetal2021/SeisMonitoring_Paper_withoutput/OUTPUT`. Those are the output from stacking.

## 1. Qualify dv/v traces
As dv/v time series of each station-channel pair has different quality in cc, data contains and **--its magnitude--: UPDATE we do NOT threshold with magnitude due to consistency**.

`01_qualifytrace_v01` saves data into hdf5. Thereshold with data contains is not applied yet. We correct **Auto-correlation asymmetric dv/v** by average and **unify components to one-side (i.e., 11, 22, 33, 12, 13, 23 is for autocorr, otherwise full 9 comp for cross-chan)**.

`015_plot_dvv_fromhdf5.ipynb` threhold out with data contains (>0.7). We also apply the data contains threshold on fitting period (2008-2013) with > 0.7.
Then, we plot preliminary figure on dv/v mean, and save it to csv file.


## 1.6 Visualize station pairs
To check which pairs have data contents enough to fit, plot map with station pairs.

## 2. preprocess precipitation and temperature
Preprocessing precipitation and temperature including smoothing. We apply low-pass filter, then downsample to synchronize with dv/v trace.

We store them to use them in model fitting.

We do not need to remove the failed datapoint from temperature time series (http://berkeleyearth.lbl.gov/auto/Stations/TAVG/Figures/172672-TAVG-Raw.pdf) as daily data does not have any failed data like spikes.


## 3. Model fitting with original dv/v to precipitation and temperature.
We fit the model from 2008 to 2013 traces to subtract from dv/v. We develop julia script to manage this process.


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
