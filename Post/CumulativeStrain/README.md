# Compute cumulative strain in Parkfield

We describe how to conduct the evaluation of strain field using GNSS data.

## 1. Download the data.
First you need to download the GNSS data. To download the data, you need a username and password. See http://garner.ucsd.edu for the information.Then, download
http://garner.ucsd.edu/pub/measuresESESES_products/Timeseries/WesternNorthAmerica/previous/sopac/WNAM_Clean_TrendNeuTimeSeries_sopac_20230416.tar.gz (2023/05/01 last accessed.)

The data is weekly updated in the directory. We stick to one of the archived data on 2023/04/16 as shown in the link. You can use the latest one if you need the recent GNSS data.

Then, locate the .tar file in the `data` directory, and untar the file by
```
mkdir data
mv xxx/WNAM_Clean_TrendNeuTimeSeries_sopac_20230416.tar ./data
cd data
mkdir WNAM_Clean_TrendNeuTimeSeries_sopac_20230416
tar xvf WNAM_Clean_TrendNeuTimeSeries_sopac_20230416.tar -C ./WNAM_Clean_TrendNeuTimeSeries_sopac_20230416
```
**NOTE:** You need to make the directory of output before the tar command.


Then, unzip the files with
```
cd WNAM_Clean_TrendNeuTimeSeries_sopac_20230416
find ./ -name \*.Z -exec unzip {} \;
```

Please check if `.neu` file can be read as ascii format.

## 2. Recompile station locations
We recompile the site file in `code/01_preprocess_GPS_BP.ipynb` used in PyTAGS by evaluating the start and end time of the GNSS data. It outputs the location of GPS in `data/BP_GPSstations.txt`

## 3. Compute strain
We forked the PyTAGS to correct the day count in the code. Please re-download by
```
git clone https://github.com/kura-okubo/PyTAGS.git
```
in the `CumulativeStrain` directory.
Then, move to `compute_triangularstrain` and run
```
cd compute_triangularstrain
sh run_pytags.sh
```
to compute the strain field.

**NOTE:** The configuration of PyTAGS such as the path to the data directory is set in `pytags.props`. We configured it in `compute_triangularstrain/pytags.props`, so you do not need to change the configuration to run the calculation of strain. Please modify it if you want to change the configuration.

## 4. Compare the strain field to the dv/v
- `code/02_postprocess_cumulativestrain_prepareGMTinput.ipynb` recompile the output of PyTAGS to the GMT format to plot the time snap shots of strain field.


- `code/03_compute_timeseriesofcumulativestrain.ipynb` computes the time series of cumulative strain for the comparison to the dv/v. Here we compute the Gaussian weighted average on the triangular elements. See `Appx/weighting_integral_Gauss/dev_weighting_integral_gauss.ipynb` to conduct the integration of 2D Gaussian weight on the triangular element.


- Before comparing the dv/v to the strain, we remove the model components associated with the temperature and the precipitation from the observed dv/v time history. Run `04_dvv_modelremoval_forcomparison.ipynb` to conduct the process of subtraction on the dv/v of channel-weighted single-station correlations.


- Compute the comparison between the dv/v processed above and the cumulative strain in `05_compare_dvv_and_strain.ipynb`. It dumps the csv datasheet associated with the time evolution of dv/v and strain, and the sensitivity obtained by the linear regression.

- Run `06_plotcomparison_dvvandstrain.ipynb` to plot the master figures for the sensitivity of dv/v to the strain. It also plots the rotated axial strain and its sensitivity.
