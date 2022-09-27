# Compute Spectrogram

`BP_autocorrPSD.jl` performs the computation of spectrogram from 2002 to 2022.
We use the Blackman-Tukey method to estimate the PSD from the daily-stacked auto-correlation functions.
To reproduce the result, we first need to compute the auto-correlation functions with auto-channel pairs (e.g. BP.CCRB..BP1-BP.CCRB..BP1).

After performing the channel correction, run the `BP_autocorrPSD.jl` to estimate the power spectrum density of the ambient seismic noise. 
