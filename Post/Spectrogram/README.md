# Compute Spectrogram

`BP_autocorrPSD.jl` performs the computation of spectrogram from 2002 to 2022.
We use the Blackman-Tukey method to estimate the PSD from the daily-stacked auto-correlation functions.
To reproduce the result, we first need to compute the auto-correlation functions with auto-channel pairs (e.g. BP.CCRB..BP1-BP.CCRB..BP1). After performing the channel correction, run the `BP_autocorrPSD.jl` to estimate the power spectrum density of the ambient seismic noise.

This data of spectrogram is available in dasway: [SeisMonitoring_PPSDdata](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/SeisMonitoring_PPSDdata.tar.gz) (1.55GB).

After unzipping the data of spectrum, run `code/plot_PPSD_BP_3cols.ipynb` to run plot the figure of PPSD.
