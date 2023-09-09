# SeisMonitoring Paper
Input files and jupyter notebooks to reproduce the processings and figures associated with the  ambient seismic noise in Parkfield.

# Documentation
See the documentation for the instruction of running the examples, downloading the cross-correlation data and the recipe of generating the figures.

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://kura-okubo.github.io/SeisMonitoring_Paper/dev)
[![Documentation](https://github.com/kura-okubo/SeisMonitoring_Paper/actions/workflows/documentation.yml/badge.svg?branch=master)](https://github.com/kura-okubo/SeisMonitoring_Paper/actions/workflows/documentation.yml)
[![DOI](https://zenodo.org/badge/343242440.svg)](https://zenodo.org/badge/latestdoi/343242440)

# Contents
## Example
Input files and the output log of the ambient seismic noise processing using [**SeisMonitoring.jl**](https://github.com/kura-okubo/SeisMonitoring.jl).

[**See the docs**](https://kura-okubo.github.io/SeisMonitoring_Paper/dev) to run the processing from downloading the data, cross-correlation, stacking, and measurement of dv/v.


We also have the tutorial of the software in different Github repository: See [**SeisMonitoring_Example**](https://github.com/kura-okubo/SeisMonitoring_Example).

<a href="https://nbviewer.org/github/kura-okubo/SeisMonitoring_Example/blob/main/code/run_seismonitoring.ipynb" target="_blank">
   <img align="left"
      src="https://raw.githubusercontent.com/jupyter/design/master/logos/Badges/nbviewer_badge.png"
      width="109" height="20">
</a>

<br>

## PostPost
Post-processing of the cross-correlation and dv/v time history.
### - [Cumulative strain](Post/CumulativeStrain)
Compute the strain field and evaluate the sensitivity of dv/v to the cumulative strain.
### - [Data availability](Post/DataAvailability)
Plot the availability of seismic data.
### - [Model fitting](Post/ModelFit)
Fitting the model to the observed dv/v time history.
### - [Spectrogram](Post/Spectrogram)
Plot the spectrogram of the continuous seismic waveform.

## Maps
Plot the map and compute the fault normal distance of the seismic stations.

## Others
Notebooks to test the codes.

## Utils
Some scripts used for manipulating the input and output of processings.

# Download list of dataset
The intermediate files of the post-processing are available in the UW dasway.

| Filename | Size | Description  | Location in repo |
|---|---|---|---|
| [SeisMonitoring_PPSDdata.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/SeisMonitoring_PPSDdata.tar.gz) | 1.4GB |  Probabilistic power spectral densities of the raw seismic data.  | `Post/Spectrogram/`|
| [BP.CCRB-BP.CCRB-11.jld2](https://kura-okubo.github.io/SeisMonitoring_Paper/dev/download_correlations/) (← Link to download docs) | ~500MB/pair | Cross-correlation functions over 20 years for a give station-channel pair with different frequency bands. | e.g. `Appx/plot_CCF/cc_channel_collection/`|
| [corrdata_BP.LCCB-BP.SCYB-11_0.9-1.2.npz](https://kura-okubo.github.io/SeisMonitoring_Paper/dev/download_correlations/) (← Link to download docs)  | ~50MB/pair | Cross-correlation function of 0.9-1.2Hz stored in `.npz` format. | `Appx/plot_CCF/data_npz/`  |
| [monitoring_stats_uwbackup_2010-2022.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_uwbackup_2010-2022.tar.gz) | 82MB | dv/v datasheet associated with the Stretching and MWCS methods | `Post/ModelFit/data/`|
| [MCMC_sampler_20000_v2_master.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_master.tar.gz)  | 3.3GB | Sampler of MCMC parameter search. | `Post/ModelFit/processed_data/` |
| [modelparam_data_master.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/modelparam_data_master.tar.gz)  | 84MB | Maximum likelihood model parameters. | `Post/ModelFit/` |
| [MCMC_sampler_20000_v2_resheal.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_resheal.tar.gz)  | 138MB | Sampler of MCMC parameter search associated with the residual healing model. | `Appx/casestudy_residual_healing/processed_data_resheal` |
| [MCMC_sampler_15000_v1_nobounds.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_15000_v1_nobounds.tar.gz)  | 2.1GB | Sampler of MCMC parameter search for the case without the bounds of model parameters. | `Others/get_MCMC_fixedparam/processed_data` |
| [modelparam_data_fixedparam.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/modelparam_data_fixedparam.tar.gz)  | 38MB | Sampler of MCMC parameter search for the case without the bounds of model parameters. | `Others/get_MCMC_fixedparam/` |
| [monitoring_stats_TACCbackup.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_TACCbackup.tar.gz) | 452MB | archived dv/v datasheet of the case study in TACC | `Other/dvvanalysis_onTACC/data/`|

# Development environment of notebooks
We developed the notebooks using Mac OS (Monterey 12.6.7). The environment of python is exported in `environment.yml`. We used the Julia v1.8.1, SeisIO v1.2.1, and SeisNoise v0.5.3. The other dependencies associated with Julia can be found in the tutorial in the [SeisMonitoring_Example](https://github.com/kura-okubo/SeisMonitoring_Example).

You can create the python environment and launch the jupyter lab by
```python
git clone https://github.com/kura-okubo/SeisMonitoring_Paper.git
cd SeisMonitoring_Paper
conda env create -f environment.yml
conda activate seismonitoring_paper
jupyter lab
```
The default browser to open the jupyter lab can be changed following [here](https://stackoverflow.com/a/47793764).

To remove (uninstall) the environment, run the followings:
```
conda deactivate
conda env remove -n seismonitoring_paper
```

# Reference
