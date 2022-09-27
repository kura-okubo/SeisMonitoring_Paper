# SeisMonitoring Paper

This repository contains
1. the examples for the use of SeisMonitoring.jl to perform the processing of ambient seismic noise.
2. scripts to post-process the data and to plot the figures.

## Case study

We performed the following case study to investigate the effect of each process flow on the dv/v time history using [TACC FRONTERA](https://frontera-portal.tacc.utexas.edu).

| id |remove eq|normalization |method| reference period |
|---|---|---|---|---|
|01| yes | no | stretching | 2010-2020 |
|02| yes | no | mwcs | 2010-2020 |
|03| yes | spectral whitening + onebit  | stretching | 2010-2020 |
|04| yes | spectral whitening + onebit | mwcs |2010-2020|
|05| yes | no | stretching | 2006-2016 |
|06| yes | no | stretching | 2007-2010 |
|07| yes | no | stretching | 2017-2020 |
|08| no  | no | stretching | 2010-2020 |
|09| yes | no | robust stuck + stretching | 2010-2020 |
|10| yes | no | compute coda Q | 2010-2020 |

We also conducted the case study in our local workstation at UW.

| id |remove eq|normalization |method| reference period |
|---|---|---|---|---|
|11| yes | no | stretching | 2010-2022 |

### How to initiate projects
To conduct the casestudy listed as above, please initiate projects and run processes as following:

1. Move to `Examples` and run `sh init_project_all.sh`.

>Julia scripts initiating projects at each stage (download, remove eq, cross-correlation, stacking & measurement) are stored in `Examples` directory. We them copy `mainparam_master.jl` to the input directory, which contains all parameters associated with processing. You can manipulate them by modifying `mainparam_master.jl` or the julia scripts with `SeisMonitoring.set_parameter()`.

> You can run from download data to stacking & dv/v measurement in one project at once; However, in this repository we separately process them for the sake of simplicity.

> The output directory is specified in the julia scripts as `project_outputdir`. We need disk space enough to store the raw and intermediate data (CCFs, stacked CorrData).

2. Go to `Examples` and run/submit jobs from download to stacking (see slurm batches to run jobs).

> We performed this casestudy with Slurm Workload Manager in [Frontera](https://frontera-portal.tacc.utexas.edu).

> The batch files are manually prepared in each input directory. For the cross-correlation stage, use `Utils/make_slurmbatch_parallel.jl` to prepare the slurm batch files to parallelize cc process with time chunks.

3. Run `sh Utils/smstats_seismonitoring.sh` to compile the outputs into csv table.

> The stacked CorrData has the measurements in its misc (`C.misc`). `run_smstats.jl` gathers the measurements from stacked corrdata and output in csv table for post processing.

## Post Processing

`Post` contains the scripts and notebooks for the followings:

1. Data availability
2. Compute dv/v with channel weighting
3. MCMC inversion of dv/v model parameters

## Plot Figures

`Figures` contains the scripts to plot
1. Map of BP network
2. Spectrogram of noise
3. Statistical analysis of model parameters associated with dv/v
