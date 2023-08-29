# Plot correlation functions

Run `Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.ipynb` to plot the 9 components of the correlation tensor over 20 years associated with a requested station pair. In the notebook, you can download the set of CCF data from `https://dasway.ess.washington.edu/shared/kokubo/parkfield_ccf_data_npz/corrdata_{stationpair}-{comp}_0.9-1.2.npz'` to plot the figures.

**NOTE:** we can also download the cross-correlation file in .jld2 from dasway and locate it in `Appx/plot_CCF/cc_channel_collection/`. Then, run `convert_ccf_threads_uwcascadia.jl` to convert the data into the `.npz` format using `convert_ccf_threads_uwcascadia.jl`. We can plot the CFs using the dataset in the `.npz` format.
