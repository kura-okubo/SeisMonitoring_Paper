# SeisMonitoring Paper

This documentation describes the followings:

1. [**How to run the example of processing using SeisMonitoring**](./run_example.md)

2. [**Download and read the correlation functions**](./download_correlations.md)

3. [**Recipe of plotting figures in the article**](./plot_figures_recipe.md)

# Download list of dataset

We stored the cross-correlation functions, dv/v data sheets, best likelihood model parameters and intermediate files of the post-processing listed below in the cloud storage of UW dasway. You can download the files from the links in the table. The location in repository indicates where you need to locate those files to conduct the post-processings using the Jupyter notebooks.

| Filename | Size | Description  | Location in repo |
|---|---|---|---|
| [{{SeisMonitoring_PPSDdata.tar.gz}](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/SeisMonitoring_PPSDdata.tar.gz) | 1.4GB |  Probabilistic power spectral densities of the raw seismic data.  | `Post/Spectrogram/`|
| [{BP.CCRB-BP.CCRB-11.jld2} ](https://kura-okubo.github.io/SeisMonitoring_Paper/stable/download_correlations/) (← Link to download docs) | ~500MB/pair | Cross-correlation functions over 20 years for a give station-channel pair with different frequency bands. | e.g. `Appx/plot_CCF/cc_channel_collection/`|
| [{corrdata_BP.LCCB-BP.SCYB-11_0.9-1.2.npz} ](https://kura-okubo.github.io/SeisMonitoring_Paper/stable/download_correlations/) (← Link to download docs)  | ~50MB/pair | Cross-correlation function of 0.9-1.2Hz stored in `.npz` format. | `Appx/plot_CCF/data_npz/`  |
| [{monitoring_stats_uwbackup_2010-2022.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_uwbackup_2010-2022.tar.gz) | 82MB | dv/v datasheet associated with the Stretching and MWCS methods | `Post/ModelFit/data/`|
| [{MCMC_sampler_20000_v2_master.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_master.tar.gz)  | 3.3GB | Sampler of MCMC parameter search. | `Post/ModelFit/processed_data/` |
| [{modelparam_data_master.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/modelparam_data_master.tar.gz)  | 84MB | Maximum likelihood model parameters. | `Post/ModelFit/` |
| [{MCMC_sampler_20000_v2_resheal.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_resheal.tar.gz)  | 138MB | Sampler of MCMC parameter search associated with the residual healing model. | `Appx/casestudy_residual_healing/processed_data_resheal` |
| [{MCMC_sampler_15000_v1_nobounds.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_15000_v1_nobounds.tar.gz)  | 2.1GB | Sampler of MCMC parameter search for the case without the bounds of model parameters. | `Others/get_MCMC_fixedparam/processed_data` |
| [{modelparam_data_fixedparam.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/modelparam_data_fixedparam.tar.gz)  | 38MB | Sampler of MCMC parameter search for the case without the bounds of model parameters. | `Others/get_MCMC_fixedparam/` |
| [{monitoring_stats_TACCbackup.tar.gz} ](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_TACCbackup.tar.gz) | 452MB | archived dv/v datasheet of the case study in TACC | `Other/dvvanalysis_onTACC/data/`|

## Reference
