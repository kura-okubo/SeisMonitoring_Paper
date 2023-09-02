# Recipe of plotting the figures

!!! note "Notebooks and codes to reproduce the figures"
    This page shows the list of the link to the notebooks and codes to plot the figures. We cleaned up the output of the cells showing the figures in the notebooks due to minimizing the size of repositories and the copyrights. To replot them, please download the data and follow the instructions documented in the directories.


- **Figure 1.** Map of Parkfield. Download and generate the input files such as `.grd` files following [`Maps/BPnetwork_introduction/README.md`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Maps/BPnetwork_introduction). Then, run [`plot_map_introduction_Parkfield.sh`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Maps/BPnetwork_introduction/)


- **Figure 2.** Number of station-channel pairs. Run [`Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb). See [`Post/ModelFit/README.md`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/README.md) for the detail.


- **Figure 3.** All dv/v time history. Run [`Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb).


- **Figure 4.** Dv/v with different station-channel pairs. Run [`Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb).


- **Figure 5.** Dv/v with different frequency bands. Run [`Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb).


- **Figure 6.** Schematic of dv/v model components. Run [`Appx/modelschematic/plot_model_schematics_dvv.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/modelschematic/plot_model_schematics_dvv.ipynb) to generate the time histories of model components. The data is imported from the `Post/ModelFit/data/interped_tempandprecip_longterm.csv`.


- **Figure 7.** Scatter matrix of MCMC using stretching associated with LCCB-SCYB. Run [`Post/ModelFit/code/plotfigure_MCMCscattermatrix_stretching.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_MCMCscattermatrix_stretching.ipynb). You need to download the output of the MCMC sampler. See the details in [`Post/ModelFit/README.md`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/README.md#5-collect-the-result-of-mcmc-sampler-and-the-dvv).


- **Figure 8.** Scatter matrix of MCMC using MWCS associated with LCCB-SCYB. Run [`Post/ModelFit/code/plotfigure_MCMCscattermatrix_mwcs.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_MCMCscattermatrix_mwcs.ipynb).


- **Figure 9.** Fitting of dv/v with stretching. Run [`Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb). You can select the `dvvmethod` as stretching or MWCS.


- **Figure 10.** Fitting of dv/v with MWCS. Run [`Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb).


- **Figure 11.** Stats plot of model parameters. Run [`Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb).


- **Figure 12.** Model fit with the residual healing model. Run [`Appx/casestudy_residual_healing/code/resheal_plot_MCMCdvvmodelfit.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/casestudy_residual_healing/code/resheal_plot_MCMCdvvmodelfit.ipynb).


- **Figure 13.** Cumulative dilation and shear strains. Run [`Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb).


- **Figure 14.** Sensitivity of dv/v to the dilation and shear strains. Run [`Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb).


- **Figure 15.** Rotated axial strain and its sensitivity. Run [`Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb).


- **Figure A1** Comparison of dv/v and LFE activity. Run [`Appx/comparison_ParkfieldTremorrate/code/comparison_ParkfieldLFErate.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/comparison_ParkfieldTremorrate/code/comparison_ParkfieldLFErate.ipynb).


---

- **Figure S1.** Map with the station names and the approximated planar fault. Run [`Maps/BPnetwork_Faultdist/BPnetwork_GMT_local/plot_BPnetwork_GMTlocal.sh`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Maps/BPnetwork_Faultdist/BPnetwork_GMT_local/plot_BPnetwork_GMTlocal.sh).


- **Figure S2.** PPSD associated with the EADB. Followng [`Post/Spectrogram/README.md`](https://github.com/kura-okubo/SeisMonitoring_Paper/tree/develop/Post/Spectrogram). The dataset of PPSD is available in [SeisMonitoring_PPSDdata.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/SeisMonitoring_PPSDdata.tar.gz), and run [`Post/Spectrogram/code/plot_PPSD_BP_3cols.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/Spectrogram/code/plot_PPSD_BP_3cols.ipynb) to plot the figures.


- **Figure S3.** Removal of earthquakes and tremors. Download the data and the remove the transient signals by running the SeisMonitoring processing in [`Appx/removal_eqandtremor/seisremoveeq_demo`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/removal_eqandtremor/seisremoveeq_demo). Then run [`Appx/removal_eqandtremor/plot_removalschematic/Tremor_signal_convert_Juliadata.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/removal_eqandtremor/plot_removalschematic/Tremor_signal_convert_Juliadata.ipynb) and [`Appx/removal_eqandtremor/plot_removalschematic/Tremor_signal_plot_removal.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/removal_eqandtremor/plot_removalschematic/Tremor_signal_plot_removal.ipynb) to plot the example of the removal of earthquakes and tremors from the raw data.


- **Figure S4.** Data availability. The datasheet of data availability is obtained by the [`Post/DataAvailability
/compute_DataAvailability.jl`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/DataAvailability/compute_DataAvailability.jl) in the cluster. Then, run [`Post/DataAvailability/plot_DataAvailability_BP.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/DataAvailability/plot_DataAvailability_BP.ipynb) to plot the figures.


- **Figure S5.** Cross-correlation functions associated with the LCCB-SCYB. Run [`Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.ipynb) to plot the CCFs over 20 years for the 9 components associated with a given station pair. As the data size is large, we plotted the all station pairs using [`Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.py`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.py) in the work stations. In the notebook, you can download an example of the set of CCF data from [here](https://kura-okubo.github.io/SeisMonitoring_Paper/dev/download_correlations/#Download-correlation-functions-in-.npz-format). **NOTE:** To recreate the `.npz` file, we can also download the cross-correlation file with .jld2 from dasway and locate it in `Appx/plot_CCF/cc_channel_collection/`. Then, run [`convert_ccf_threads_uwcascadia.jl`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/plot_CCF/code/convert_ccf_threads_uwcascadia.jl) to convert the data to the `.npz` format. We can plot the CFs using the dataset in the `.npz` format.


- **Figure S6.** Sensitivity kernel with depth. Run [`Appx/BP_sensitivity_kernel/plot_sensitivity_kernel_Parkfield.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/BP_sensitivity_kernel/plot_sensitivity_kernel_Parkfield.ipynb). See the details in [`Appx/BP_sensitivity_kernel/README.md`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/BP_sensitivity_kernel/README.md).


- **Figure S7.** Trade-off between S, τmin and τmax. Run [`Appx/tradeoff_logheal_SandTmax/code/tradeoff_logheal_SandTminTmax_v2.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/tradeoff_logheal_SandTmax/code/tradeoff_logheal_SandTminTmax_v2.ipynb) to conduct the MCMC parameter search associated with the S, tau_min and tau_max. Then, run [`tradeoff_logheal_SandTmax/code/tradeoff_logheal_SandTminTmax_plotmaster.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/tradeoff_logheal_SandTmax/code/tradeoff_logheal_SandTminTmax_plotmaster.ipynb) to plot the summary figure.


- **Figure S8.** Dv/v time histories with channel-weighted station pairs for the case with the stretching. Run [`Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb).


- **Figure S9.** Dv/v time histories with channel-weighted station pairs for the case with the MWCS. Run [`Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb).


- **Figure S10.** Scatter matrix with MWCS, residual healing model. Run [`Appx/casestudy_residual_healing/code/resheal_plot_MCMCscattermatrix_mwcs.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/casestudy_residual_healing/code/resheal_plot_MCMCscattermatrix_mwcs.ipynb)


- **Figure S11.** The coefficient of b with the fault-normal distance. Run [`Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb).


- **Figure S12.** The scaling of parallelization. Run [`Appx/Scaling_Frontera/plot_scaling_parallelization_master.ipynb`](https://github.com/kura-okubo/SeisMonitoring_Paper/blob/develop/Appx/Scaling_Frontera/plot_scaling_parallelization_master.ipynb).

