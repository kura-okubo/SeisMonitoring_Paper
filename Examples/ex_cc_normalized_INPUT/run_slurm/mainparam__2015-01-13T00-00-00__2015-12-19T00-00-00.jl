#Save at 2021-03-12T06:00:04 by c205-016.frontera.tacc.utexas.edu
using Dates, DataStructures
InputDict = OrderedDict(
"project_name"  => ("ex_cc_normalized", String, "project name."),
"project_inputdir"  => (".//ex_cc_normalized_INPUT", String, "project input directory which you initiated with init_project()."),
"project_outputdir"  => ("/scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_normalized_OUTPUT", String, "project output directory which you initiated with init_project()."),
"starttime"  => ("2015-01-13T00:00:00", DateTime, "process start time"),
"endtime"  => ("2015-12-19T00:00:00", DateTime, "process end time"),
"sampling_frequency"  => ("20", Float64, "[Hz] Processing sampling frequency. Downsampling is applied when downloaded original data is higher sampling frequency."),
"freqency_band"  => ("0.2, 0.5, 0.9, 1.2, 2.0", Float64, "Frequency bands to be analyzed."),
"MAX_MEM_USE"  => ("3.0", Float64, "[GB] Maximum memory use per core in the environment."),
"download_time_unit"  => ("86400", Int64, "[s] Unit time of data request. (e.g. request data for each 10minutes."),
"download_margin"  => ("300", Int64, "[s] Download margin to be clipped to avoid edge effect."),
"requeststation_file"  => ("/scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_normalized_OUTPUT/ex_cc_normalized.jld2", String, "Request station dataframe saved in JLD2. See default_requeststations.jld2"),
"IsResponseRemove"  => ("true", Bool, "True if remove instrumental response while downloading data."),
"IsLocationBox"  => ("false", Bool, "True if using lat-lon box for request."),
"reg"  => ("35.7, 36.1, -120.7, -120.2", Float64, "minlat, maxlat, minlon, maxlon"),
"Istmpfilepreserved"  => ("false", Bool, "True if you want to preserve temporal files (same size as raw data.)"),
"IsXMLfilepreserved"  => ("false", Bool, "True if you want to preserve station xml files."),
"numstationperrequest"  => ("1", Int64, "Advanced: number of station per one HTTP request."),
"outputformat"  => ("JLD2", String, "JLD2 or ASDF: use JLD2 if you perform the following processes with SeisMonitoring.jl"),
"RawData_path"  => ("default", String, "\"default\" or absolute/relative path to rawdata. \"default\" links to project output directory."),
"IsKurtosisRemoval"  => ("true", Bool, "Apply Kurtosis removal."),
"IsSTALTARemoval"  => ("true", Bool, "Apply STA/LTA removal."),
"IsWhitening"  => ("false", Bool, "Apply Spectral whitening."),
"freqmin_whiten"  => ("0.1", Float64, "Minimum cutoff frequency for spectral whitening"),
"freqmax_whiten"  => ("1.0", Float64, "Maximum cutoff frequency for spectral whitening"),
"Append_alltraces"  => ("false", Bool, "Append kurtosis and stalta traces to SeisChannel (this increases data size)"),
"shorttime_window"  => ("180", Float64, "Short-time window used to compute kurtosis and sta/lta"),
"longtime_window"  => ("86400", Float64, "Long-time window used to compute sta/lta"),
"timewindow_overlap"  => ("60", Float64, "Short-time window overlap to compute kurtosis and sta/lta"),
"kurtosis_threshold"  => ("3.0", Float64, "Kurtosis removal threshold (The normal distribution of kurtosis is normalized to be zero.)"),
"stalta_threshold"  => ("3.0", Float64, "STA/LTA removal threshold (For our purpose, this threshold is smaller than ordinal detection.)"),
"stalta_absoluteclip"  => ("0.1", Float64, "[unit-of-data] clip the signal above this value (basically for instrumental error.)"),
"fixed_tukey_margin"  => ("30", Float64, "[s] Fixed turkey margin; duration of decay outside of zero padding"),
"IsIsolateComponents"  => ("false", Bool, "Advanced: isolating comonents at same station"),
"cc_time_unit"  => ("86400", Int64, "[s] Unit time of cross-correlation window. e.g. 60*60*24 = 86400 indicates daily-cross correlation."),
"cc_len"  => ("3600", Int64, "[s] short-time window cross-correlation length"),
"cc_step"  => ("1800", Int64, "[s] cross-correlation window step"),
"maxlag"  => ("100", Float64, "[s] Maximum time lag of cross-correlation."),
"cc_RawData_path"  => ("/scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_removeeq_whiten_OUTPUT/seismicdata/seisremoveeq", String, "\"default\" or absolute/relative path to rawdata. \"default\" links to project OUTPUT/EQRemovedData.jld2."),
"cc_normalization"  => ("none", String, "none, coherence or deconvolution."),
"corr_type"  => ("CC", String, "Type of correlation: `CC` (standard cross-correlation) or `PCC` (phase cross-correlation). See also doc in SeisNoise.jl"),
"pairs_option"  => ("all", Array{String,1}, "\"all\" or list of component pairs. e.g. XX, YY, ZZ"),
"chanpair_type"  => ("all", Array{String,1}, "\"all\" or list of channel pair type. e.g. auto-achan, cross-achan, cross-xchan"),
"data_contents_fraction"  => ("0.5", Float64, "Advanced: discard cross-correlation if data fraction within cc_time_unit is less that this value."),
"IsOnebit"  => ("true", Bool, "Apply One-bit normalization."),
"smoothing_windowlength"  => ("7", Int64, "Advanced: number of points for boxcar smoothing window on coherence and deconvolution."),
"water_level"  => ("1e-4", Float64, "Advanced: waterlevel [0.0 if not applied] on spectrum normalization with coherence and deconvolution method."),
"cc_bpfilt_method"  => ("Wavelet", String, "Frequency decomposition method. \"Butterworth\" or \"Wavelet\"."),
"cc_taper_α0"  => ("0.2", Float64, "Advanced: Lowest tapering fraction for frequency adaptive tapering."),
"cc_taper_αmax"  => ("0.3", Float64, "Advanced: Highest tapering fraction for frequency adaptive tapering."),
"cc_medianmute_max"  => ("3.0", Float64, "Advanced: Threshold factor of median mute within cc_time_unit. NCF is removed if maximum(abs.(corr[:,i])) > cc_medianmute_max * median(maximum(abs.(corr)), dims=1)"),
"cc_medianmute_min"  => ("0.1", Float64, "Advanced: Threshold factor of median mute within cc_time_unit. NCF is removed if maximum(abs.(corr[:,i])) < cc_medianmute_min * median(maximum(abs.(corr)), dims=1)"),
"IsPreStack"  => ("true", Bool, "Advanced: Pre-stacking corrdata within each cc_time_unit when assembling the corrdata for the sake of saving memory use."),
"timechunk_increment"  => ("5", Int64, "Advanced: Number of time chunk increment for parallelization: large number is more efficient, but increase memory use."),
"stack_RawData_dir"  => ("/home1/07208/kokubo09/scratch/BP_v23_OUTPUT/cc", String, "\"default\" or absolute/relative path to cc directory. \"default\" links to project OUTPUT/cc."),
"use_local_tmpdir"  => ("true", Bool, "True if using local /tmp diretory. Please set true when running in cluster to avoid massive file I/O."),
"stack_method"  => ("selective", String, "stacking method: linear, selective, robust, pws, robustpws are available"),
"collect_stationpairs"  => ("false", Bool, "true if correct station pairs. Stacking without this process does not work."),
"compute_reference"  => ("true", Bool, "true if compute reference stack for longterm stack."),
"compute_shorttimestack"  => ("true", Bool, "true if compute shorttime stack for continuous monitoring."),
"stack_pairs_option"  => ("all", Array{String,1}, "\"all\" or list of component pairs. e.g. XX, YY, ZZ"),
"averagestack_factor"  => ("30", Int64, "Integer factor of cc_time_unit for stacking duration. e.g. cc_time_unit = 1day and averagestack_factor=30 provides 30days moving window average."),
"averagestack_step"  => ("15", Int64, "Step of averagestack window."),
"min_cc_datafraction"  => ("0.5", Float64, "Advanced: discard cross-correlation if data fraction within stacking period is less that this value."),
"reference_starttime"  => ("2010-01-01T00:00:00", DateTime, "reference start time"),
"reference_endtime"  => ("2020-01-01T00:00:00", DateTime, "reference end time"),
"dist_threshold"  => ("1.0", Float64, "Threshold of distance used for selective stacking."),
"distance_type"  => ("CorrDist", String, "Advanced: Distance type used in selective stacking. See https://github.com/JuliaStats/Distances.jl for available types."),
"IsZeropadBeforeStack"  => ("false", Bool, "Zero padding outside of coda window using tukey window before stacking."),
"background_vel"  => ("1000.0", Float64, "[m/s] Approximation of background wave velocity, just used for coda slicing."),
"min_ballistic_twin"  => ("1.0", Float64, "[s] Explicit ballistic time window to remove coherence around zero timelag. This is aimed to remove it mainly for auto-correlation."),
"max_coda_length"  => ("60.0", Float64, "[s] Maximum coda window length."),
"mwcc_threshold"  => ("0.5", Float64, " mwcc slice coda threshold."),
"mwcc_len_α"  => ("3.0", Float64, "moving window size factor (size = (mwcc_len_α/fm)*fs [point])."),
"min_codalength_α"  => ("1.0", Float64, "Threshold of minimum codawindow length: min_codalength = min_codalength_α*mwcc window length."),
"codaslice_debugplot"  => ("false", Bool, "If plot debug figures for coda slicing."),
"nondim_max_coda_length"  => ("30.0", Float64, "Deprecated: nondimensional maximum coda window length"),
"nondim_codamaxlag"  => ("60.0", Float64, "Deprecated: coda max lag where kinetic energy is evaluated."),
"coda_energy_threshold"  => ("-1.0", Float64, "Deprecated: Advanced: Threshold for attenuation decay."),
"IsAlternateRefChannel"  => ("true", Bool, "Advanced: Allow for using alternative station channel for reference. (e.g. BP.LCCB..BP1-BP.MMNB..BP1 is used as reference for BP.LCCB..SP1-BP.MMNB..SP1)"),
"keep_corrtrace"  => ("false", Bool, "Advanced: Keep corr trace in CorrData if true. (require the strage to save corrs.)"),
"measurement_method"  => ("stretching", String, "Stretching method for measuring dv/v and dQ^{-1}. \"stretching\",\"mwcs\",\"wcc\",\"dtw\",\"dualstretching\" "),
"mwcs_window_length"  => ("6.0", Float64, "[s] The moving window length"),
"mwcs_window_step"  => ("3.0", Float64, "[s] The step to jump for the moving window."),
"mwcs_smoothing_half_win"  => ("5", Int64, "MWCS smoothing half windown length."),
"stretch_debugplot"  => ("false", Bool, "If plot debug figures for streching."),
"dvv_stretching_range"  => ("0.02", Float64, "Advanced: dvv stretching trial range for dvv (+- abs(dvv_stretching_range))."),
"dvv_stretching_Ntrial"  => ("201", Int64, "Advanced: dvv stretching trial number for dvv."),
)