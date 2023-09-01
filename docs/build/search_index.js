var documenterSearchIndex = {"docs":
[{"location":"run_example.html#Run-examples-of-processing","page":"Run examples","title":"Run examples of processing","text":"","category":"section"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"The case studies used in the manuscript are followings:","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"id remove eq temporal/spectral normalization dv/v method reference period\n00 yes no stretching 2010-2022\n01 yes no mwcs 2010-2022","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"You can download the dv/v datasheet from monitoring_stats_uwbackup_2010-2022.tar.gz","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"In the early development of software tools using TACC FRONTERA, we performed the following case studies for the data between 2002-2020 to investigate the effect of parameters associated with the process flow on the dv/v time history, which are archived as follows.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"id remove eq temporal/spectral normalization dv/v method reference period\n02 yes no stretching 2010-2020\n03 yes no mwcs 2010-2020\n04 yes spectral whitening + onebit stretching 2010-2020\n05 yes spectral whitening + onebit mwcs 2010-2020\n06 yes no stretching 2006-2016\n07 yes no stretching 2007-2010\n08 yes no stretching 2017-2020\n09 no no stretching 2010-2020\n10 yes no robust stuck + stretching 2010-2020\n11 yes no compute coda Q 2010-2020","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Archived dv/v datasheets\nWe investigated the case studies listed above to check the effect of reference period, normalizations and stacking methods to the dv/v time history. Indeed, it only causes minor differences in dv/v and does not modify the conclusions. However, as we have updated the software tools even after the the jobs done in FRONTERA and extended the study period from 2020 to 2022, we keep those case studies as the archives here.   ","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"The archived dv/v datasheets are available in monitoring_stats_TACCbackup.tar.gz","category":"page"},{"location":"run_example.html#How-to-run-the-projects","page":"Run examples","title":"How to run the projects","text":"","category":"section"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"To conduct the casestudy listed as above, please initiate projects and run processes as following:","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"Move to Examples and run sh init_project_all.sh.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nJulia scripts initiating projects at each stage (download, remove eq, cross-correlation, stacking & measurement) are stored in Examples directory. We them copy mainparam_master.jl to the input directory, which contains all parameters associated with processing. You can manipulate them by modifying mainparam_master.jl or the julia scripts with SeisMonitoring.set_parameter().","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nYou can run from download data to stacking & dv/v measurement in one project at once; However, in this repository we separately process them for the sake of simplicity.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nThe output directory is specified in the julia scripts as project_outputdir. We need disk space enough to store the raw and intermediate data (CCFs, stacked CorrData).","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"Go to Examples and run/submit jobs from download to stacking (see slurm batches to run jobs).","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nWe performed this casestudy with Slurm Workload Manager in Frontera.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nThe batch files are manually prepared in each input directory. For the cross-correlation stage, use Utils/make_slurmbatch_parallel.jl to prepare the slurm batch files to parallelize cc process with time chunks.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"Run sh Utils/smstats_seismonitoring.sh to compile the outputs into csv table.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"note: Note\nThe stacked CorrData has the measurements in its misc (C.misc). run_smstats.jl gathers the measurements from stacked corrdata and output in csv table for post processing.","category":"page"},{"location":"run_example.html#Development-environments","page":"Run examples","title":"Development environments","text":"","category":"section"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"We conducted the case study of the ambient seismic noise processing using TACC FRONTERA and the local workstation (48cores) installed in UW Denolle Lab.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"Reference of FRONTERA: Dan Stanzione, John West, R. Todd Evans, Tommy Minyard, Omar Ghattas, and Dhabaleswar K. Panda. 2020. Frontera: The Evolution of Leadership Computing at the National Science Foundation. In Practice and Experience in Advanced Research Computing (PEARC ’20), July 26–30, 2020, Portland, OR, USA. ACM, New York, NY, USA, 11 pages. https://doi.org/10.1145/3311790.3396656","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"We also used the FASRC Cannon cluster supported by the FAS Division of Science Research Computing Group at Harvard University for the early development of the software tools.","category":"page"},{"location":"run_example.html","page":"Run examples","title":"Run examples","text":"We used the seismic data operated by the High Resolution Seismic Network (HRSN) doi:10.7932/HRSN.","category":"page"},{"location":"download_correlations.html#Download-correlation-functions","page":"Download CFs","title":"Download correlation functions","text":"","category":"section"},{"location":"download_correlations.html","page":"Download CFs","title":"Download CFs","text":"<!--- referemce: https://cs50.stackexchange.com/a/20716, https://stackoverflow.com/a/71051633 --->\n<div>\n<form method=\"get\">\n<label>https://dasway.ess.washington.edu/shared/kokubo/parkfield_correlations/</label>\n  <select name=\"correlations\" id=\"correlations_st\">\n      <option value=\"BP.CCRB-BP.CCRB\">BP.CCRB-BP.CCRB</option>\n        <option value=\"BP.CCRB-BP.EADB\">BP.CCRB-BP.EADB</option>\n        <option value=\"BP.CCRB-BP.FROB\">BP.CCRB-BP.FROB</option>\n        <option value=\"BP.CCRB-BP.GHIB\">BP.CCRB-BP.GHIB</option>\n        <option value=\"BP.CCRB-BP.JCNB\">BP.CCRB-BP.JCNB</option>\n        <option value=\"BP.CCRB-BP.JCSB\">BP.CCRB-BP.JCSB</option>\n        <option value=\"BP.CCRB-BP.LCCB\">BP.CCRB-BP.LCCB</option>\n        <option value=\"BP.CCRB-BP.MMNB\">BP.CCRB-BP.MMNB</option>\n        <option value=\"BP.CCRB-BP.RMNB\">BP.CCRB-BP.RMNB</option>\n        <option value=\"BP.CCRB-BP.SCYB\">BP.CCRB-BP.SCYB</option>\n        <option value=\"BP.CCRB-BP.SMNB\">BP.CCRB-BP.SMNB</option>\n        <option value=\"BP.CCRB-BP.VARB\">BP.CCRB-BP.VARB</option>\n        <option value=\"BP.CCRB-BP.VCAB\">BP.CCRB-BP.VCAB</option>\n        <option value=\"BP.EADB-BP.EADB\">BP.EADB-BP.EADB</option>\n        <option value=\"BP.EADB-BP.FROB\">BP.EADB-BP.FROB</option>\n        <option value=\"BP.EADB-BP.GHIB\">BP.EADB-BP.GHIB</option>\n        <option value=\"BP.EADB-BP.JCNB\">BP.EADB-BP.JCNB</option>\n        <option value=\"BP.EADB-BP.JCSB\">BP.EADB-BP.JCSB</option>\n        <option value=\"BP.EADB-BP.LCCB\">BP.EADB-BP.LCCB</option>\n        <option value=\"BP.EADB-BP.MMNB\">BP.EADB-BP.MMNB</option>\n        <option value=\"BP.EADB-BP.RMNB\">BP.EADB-BP.RMNB</option>\n        <option value=\"BP.EADB-BP.SCYB\">BP.EADB-BP.SCYB</option>\n        <option value=\"BP.EADB-BP.SMNB\">BP.EADB-BP.SMNB</option>\n        <option value=\"BP.EADB-BP.VARB\">BP.EADB-BP.VARB</option>\n        <option value=\"BP.EADB-BP.VCAB\">BP.EADB-BP.VCAB</option>\n        <option value=\"BP.FROB-BP.FROB\">BP.FROB-BP.FROB</option>\n        <option value=\"BP.FROB-BP.GHIB\">BP.FROB-BP.GHIB</option>\n        <option value=\"BP.FROB-BP.JCNB\">BP.FROB-BP.JCNB</option>\n        <option value=\"BP.FROB-BP.JCSB\">BP.FROB-BP.JCSB</option>\n        <option value=\"BP.FROB-BP.LCCB\">BP.FROB-BP.LCCB</option>\n        <option value=\"BP.FROB-BP.MMNB\">BP.FROB-BP.MMNB</option>\n        <option value=\"BP.FROB-BP.RMNB\">BP.FROB-BP.RMNB</option>\n        <option value=\"BP.FROB-BP.SCYB\">BP.FROB-BP.SCYB</option>\n        <option value=\"BP.FROB-BP.SMNB\">BP.FROB-BP.SMNB</option>\n        <option value=\"BP.FROB-BP.VARB\">BP.FROB-BP.VARB</option>\n        <option value=\"BP.FROB-BP.VCAB\">BP.FROB-BP.VCAB</option>\n        <option value=\"BP.GHIB-BP.GHIB\">BP.GHIB-BP.GHIB</option>\n        <option value=\"BP.GHIB-BP.JCNB\">BP.GHIB-BP.JCNB</option>\n        <option value=\"BP.GHIB-BP.JCSB\">BP.GHIB-BP.JCSB</option>\n        <option value=\"BP.GHIB-BP.LCCB\">BP.GHIB-BP.LCCB</option>\n        <option value=\"BP.GHIB-BP.MMNB\">BP.GHIB-BP.MMNB</option>\n        <option value=\"BP.GHIB-BP.RMNB\">BP.GHIB-BP.RMNB</option>\n        <option value=\"BP.GHIB-BP.SCYB\">BP.GHIB-BP.SCYB</option>\n        <option value=\"BP.GHIB-BP.SMNB\">BP.GHIB-BP.SMNB</option>\n        <option value=\"BP.GHIB-BP.VARB\">BP.GHIB-BP.VARB</option>\n        <option value=\"BP.GHIB-BP.VCAB\">BP.GHIB-BP.VCAB</option>\n        <option value=\"BP.JCNB-BP.JCNB\">BP.JCNB-BP.JCNB</option>\n        <option value=\"BP.JCNB-BP.JCSB\">BP.JCNB-BP.JCSB</option>\n        <option value=\"BP.JCNB-BP.LCCB\">BP.JCNB-BP.LCCB</option>\n        <option value=\"BP.JCNB-BP.MMNB\">BP.JCNB-BP.MMNB</option>\n        <option value=\"BP.JCNB-BP.RMNB\">BP.JCNB-BP.RMNB</option>\n        <option value=\"BP.JCNB-BP.SCYB\">BP.JCNB-BP.SCYB</option>\n        <option value=\"BP.JCNB-BP.SMNB\">BP.JCNB-BP.SMNB</option>\n        <option value=\"BP.JCNB-BP.VARB\">BP.JCNB-BP.VARB</option>\n        <option value=\"BP.JCNB-BP.VCAB\">BP.JCNB-BP.VCAB</option>\n        <option value=\"BP.JCSB-BP.JCSB\">BP.JCSB-BP.JCSB</option>\n        <option value=\"BP.JCSB-BP.LCCB\">BP.JCSB-BP.LCCB</option>\n        <option value=\"BP.JCSB-BP.MMNB\">BP.JCSB-BP.MMNB</option>\n        <option value=\"BP.JCSB-BP.RMNB\">BP.JCSB-BP.RMNB</option>\n        <option value=\"BP.JCSB-BP.SCYB\">BP.JCSB-BP.SCYB</option>\n        <option value=\"BP.JCSB-BP.SMNB\">BP.JCSB-BP.SMNB</option>\n        <option value=\"BP.JCSB-BP.VARB\">BP.JCSB-BP.VARB</option>\n        <option value=\"BP.JCSB-BP.VCAB\">BP.JCSB-BP.VCAB</option>\n        <option value=\"BP.LCCB-BP.LCCB\">BP.LCCB-BP.LCCB</option>\n        <option value=\"BP.LCCB-BP.MMNB\">BP.LCCB-BP.MMNB</option>\n        <option value=\"BP.LCCB-BP.RMNB\">BP.LCCB-BP.RMNB</option>\n        <option value=\"BP.LCCB-BP.SCYB\">BP.LCCB-BP.SCYB</option>\n        <option value=\"BP.LCCB-BP.SMNB\">BP.LCCB-BP.SMNB</option>\n        <option value=\"BP.LCCB-BP.VARB\">BP.LCCB-BP.VARB</option>\n        <option value=\"BP.LCCB-BP.VCAB\">BP.LCCB-BP.VCAB</option>\n        <option value=\"BP.MMNB-BP.MMNB\">BP.MMNB-BP.MMNB</option>\n        <option value=\"BP.MMNB-BP.RMNB\">BP.MMNB-BP.RMNB</option>\n        <option value=\"BP.MMNB-BP.SCYB\">BP.MMNB-BP.SCYB</option>\n        <option value=\"BP.MMNB-BP.SMNB\">BP.MMNB-BP.SMNB</option>\n        <option value=\"BP.MMNB-BP.VARB\">BP.MMNB-BP.VARB</option>\n        <option value=\"BP.MMNB-BP.VCAB\">BP.MMNB-BP.VCAB</option>\n        <option value=\"BP.RMNB-BP.RMNB\">BP.RMNB-BP.RMNB</option>\n        <option value=\"BP.RMNB-BP.SCYB\">BP.RMNB-BP.SCYB</option>\n        <option value=\"BP.RMNB-BP.SMNB\">BP.RMNB-BP.SMNB</option>\n        <option value=\"BP.RMNB-BP.VARB\">BP.RMNB-BP.VARB</option>\n        <option value=\"BP.RMNB-BP.VCAB\">BP.RMNB-BP.VCAB</option>\n        <option value=\"BP.SCYB-BP.SCYB\">BP.SCYB-BP.SCYB</option>\n        <option value=\"BP.SCYB-BP.SMNB\">BP.SCYB-BP.SMNB</option>\n        <option value=\"BP.SCYB-BP.VARB\">BP.SCYB-BP.VARB</option>\n        <option value=\"BP.SCYB-BP.VCAB\">BP.SCYB-BP.VCAB</option>\n        <option value=\"BP.SMNB-BP.SMNB\">BP.SMNB-BP.SMNB</option>\n        <option value=\"BP.SMNB-BP.VARB\">BP.SMNB-BP.VARB</option>\n        <option value=\"BP.SMNB-BP.VCAB\">BP.SMNB-BP.VCAB</option>\n        <option value=\"BP.VARB-BP.VARB\">BP.VARB-BP.VARB</option>\n        <option value=\"BP.VARB-BP.VCAB\">BP.VARB-BP.VCAB</option>\n        <option value=\"BP.VCAB-BP.VCAB\">BP.VCAB-BP.VCAB</option>\n  </select>\n  <label>-</label>\n  <select name=\"correlations\" id=\"correlations_chan\">\n        <option value=\"11\">11</option>\n        <option value=\"12\">12</option>\n        <option value=\"13\">13</option>\n        <option value=\"21\">21</option>\n        <option value=\"22\">22</option>\n        <option value=\"23\">23</option>\n        <option value=\"31\">31</option>\n        <option value=\"32\">32</option>\n        <option value=\"33\">33</option>\n  </select>\n  <label>.jld2</label>\n</form>\n<br>\n<button type=\"button\" id=\"submit\" style=\"font-size: 13px;\">Download</button>\n\n</div>\n\n<script>\ndocument.getElementById('submit').onclick = function(){\n  window.location.href = \"https://dasway.ess.washington.edu/shared/kokubo/parkfield_correlations/\"+document.getElementById('correlations_st').value+\"-\"+document.getElementById('correlations_chan').value+\".jld2\";\n};\n</script>\n","category":"page"},{"location":"index.html#SeisMonitoring-Paper","page":"Index","title":"SeisMonitoring Paper","text":"","category":"section"},{"location":"index.html","page":"Index","title":"Index","text":"This documentation describes the followings:","category":"page"},{"location":"index.html","page":"Index","title":"Index","text":"How to run the example of processing using SeisMonitoring\nDownload and read the correlation functions\nRecipe of plotting figures in the article","category":"page"},{"location":"index.html#Reference","page":"Index","title":"Reference","text":"","category":"section"},{"location":"plot_figures_recipe.html#Recipe-of-plotting-the-figures","page":"Recipe of figures","title":"Recipe of plotting the figures","text":"","category":"section"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 1. Map of Parkfield. Download and generate the input files such as .grd files following Maps/BPnetwork_introduction/README.md. Then, run plot_map_introduction_Parkfield.sh","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 2. Number of station-channel pairs. Run Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb. See Post/ModelFit/README.md for the detail.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 3. All dv/v time history. Run Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 4. Dv/v with different station-channel pairs. Run Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 5. Dv/v with different frequency bands. Run Post/ModelFit/code/plotfigure_plotdvvpsd.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 6. Schematic of dv/v model components. Run Appx/modelschematic/plot_model_schematics_dvv.ipynb to generate the time histories of model components. The data is imported from the Post/ModelFit/data/interped_tempandprecip_longterm.csv.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 7. Scatter matrix of MCMC with stretching, LCCB-SCYB. Run Post/ModelFit/code/plotfigure_MCMCscattermatrix_stretching.ipynb. You need to download the output of the MCMC sampler. See the details in Post/ModelFit/README.md","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 8. Scatter matrix of MCMC with MWCS, LCCB-SCYB. Run Post/ModelFit/code/plotfigure_MCMCscattermatrix_mwcs.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 9. Fitting of dv/v with stretching. Run Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb. You can select the dvvmethod as stretching or MWCS.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 10. Fitting of dv/v with MWCS. Run Post/ModelFit/code/plotfigure_MCMCdvvmodelfit.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 11. Stats plot of model parameters. Run Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 12. Model fit with the residual healing model. Run Appx/casestudy_residual_healing/code/resheal_plot_MCMCdvvmodelfit.ipynb","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 13. Cumulative dilation and shear strains. Run Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 14. Sensitivity of dv/v to the dilation and shear strains. Run Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure 15. Rotated axial strain and its sensitivity. Run Post/CumulativeStrain/code/06_plotcomparison_dvvandstrain.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure A1 Comparison of dv/v and LFE activity. Run Appx/comparison_ParkfieldTremorrate/code/comparison_ParkfieldLFErate.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S1. Map with the station names and the approximated planar fault. Run BPnetwork_GMT_local/plot_BPnetwork_GMTlocal.sh.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S2. PPSD associated with the EADB. Followng Post/Spectrogram/README.md. The dataset of PPSD is available online, and run Post/Spectrogram/code/plot_PPSD_BP_3cols.ipynb to plot the figures.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S3. Removal of earthquakes and tremors. Download the data and the remove the transient signals by running the processing in Appx/seisremoveeq_demo. Then run Appx/Post/Spectrogram/Tremor_signal_convert_Juliadata.ipynb and Appx/Post/Spectrogram/Tremor_signal_plot_removal.ipynb to plot the example of the removal of earthquakes and tremors from the raw data.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S4. Data availability. The datasheet of data availability is obtained by the compute_DataAvailability.jl in the cluster. Then, run Post/DataAvailability/plot_DataAvailability_BP.ipynb to plot the figures.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S5. Cross-correlation functions associated with the LCCB-SCYB. Run Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.ipynb to plot the CCFs over 20 years for the 9 components associated with a given station pair. As the data size is large, we plotted the all station pairs using Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.py in the work stations. In the notebook, you can download an example of the set of CCF data from https://dasway.ess.washington.edu/shared/kokubo/parkfield_ccf_data_npz/corrdata_{stationpair}-{comp}_0.9-1.2.npz (e.g. corrdata_BP.CCRB-BP.EADB-11_0.9-1.2.npz).  NOTE: To recreate the .npz file, we can also download the cross-correlation file with .jld2 from dasway and locate it in Appx/plot_CCF/cc_channel_collection/. Then, run convert_ccf_threads_uwcascadia.jl to convert the data into the .npz format using convert_ccf_threads_uwcascadia.jl. We can plot the CFs using the dataset with the .npz format.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S6. Sensitivity kernel with depth. Run Appx/BP_sensitivity_kernel/plot_sensitivity_kernel_Parkfield.ipynb. See the details in Appx/BP_sensitivity_kernel/README.md.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S7. Trade-off between S, τmin and τmax. Run Appx/tradeoff_logheal_SandTmax/tradeoff_logheal_SandTminTmax_v2.ipynb to conduct the MCMC parameter search associated with the S, taumin and taumax. Then, run tradeoff_logheal_SandTmax/tradeoff_logheal_SandTminTmax_plotmaster.ipynb to plot the summary figure.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S8. Dv/v time histories with channel-weighted station pairs for the case with the stretching. Run Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S9. Dv/v time histories with channel-weighted station pairs for the case with the MWCS. Run Post/ModelFit/code/plotfigure_alldvvmodelfit.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S10. Scatter matrix with MWCS, residual healing model. Run Appx/casestudy_residual_healing/code/resheal_plot_MCMCscattermatrix_mwcs.ipynb","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S11. The coefficient of b with the fault-normal distance. Run Post/ModelFit/code/modelfit_07_MCMC_plotstats.ipynb.","category":"page"},{"location":"plot_figures_recipe.html","page":"Recipe of figures","title":"Recipe of figures","text":"Figure S12. The scaling of parallelization. Run Appx/Scaling_Frontera/plot_scaling_parallelization_master.ipynb.","category":"page"}]
}
