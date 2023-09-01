# Run examples of processing

The case studies used in the manuscript are followings:

| id |remove eq|temporal/spectral normalization |dv/v method| reference period |
|---|---|---|---|---|
|00| yes | no | stretching | 2010-2022 |
|01| yes | no | mwcs | 2010-2022 |

You can download the dv/v datasheet from [`monitoring_stats_uwbackup_2010-2022.tar.gz`](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/monitoring_stats_uwbackup_2010-2022.tar.gz)

In the early development of software tools using [TACC FRONTERA](https://frontera-portal.tacc.utexas.edu), we performed the following case studies for the data between 2002-2020 to investigate the effect of parameters associated with the process flow on the dv/v time history, which are archived as follows.

| id |remove eq|temporal/spectral normalization |dv/v method| reference period |
|---|---|---|---|---|
|02| yes | no | stretching | 2010-2020 |
|03| yes | no | mwcs | 2010-2020 |
|04| yes | spectral whitening + onebit  | stretching | 2010-2020 |
|05| yes | spectral whitening + onebit | mwcs |2010-2020|
|06| yes | no | stretching | 2006-2016 |
|07| yes | no | stretching | 2007-2010 |
|08| yes | no | stretching | 2017-2020 |
|09| no  | no | stretching | 2010-2020 |
|10| yes | no | robust stuck + stretching | 2010-2020 |
|11| yes | no | compute coda Q | 2010-2020 |

!!! note "Archived dv/v datasheets"
    We investigated the case studies listed above to check the effect of reference period, normalizations and stacking methods to the dv/v time history. Indeed, it only causes minor differences in dv/v and does not modify the conclusions. However, as we have updated the software tools even after the the jobs done in FRONTERA and extended the study period from 2020 to 2022, we keep those case studies as the archives here.   

The archived dv/v datasheets are available in [`monitoring_stats_TACCbackup.tar.gz`]()



## How to run the projects
To conduct the casestudy listed as above, please initiate projects and run processes as following:

1. Move to `Examples` and run `sh init_project_all.sh`.

!!! note
    Julia scripts initiating projects at each stage (download, remove eq, cross-correlation, stacking & measurement) are stored in `Examples` directory. We them copy `mainparam_master.jl` to the input directory, which contains all parameters associated with processing. You can manipulate them by modifying `mainparam_master.jl` or the julia scripts with `SeisMonitoring.set_parameter()`.

!!! note
    You can run from download data to stacking & dv/v measurement in one project at once; However, in this repository we separately process them for the sake of simplicity.

!!! note
    The output directory is specified in the julia scripts as `project_outputdir`. We need disk space enough to store the raw and intermediate data (CCFs, stacked CorrData).

2. Go to `Examples` and run/submit jobs from download to stacking (see slurm batches to run jobs).

!!! note
    We performed this casestudy with Slurm Workload Manager in [Frontera](https://frontera-portal.tacc.utexas.edu).

!!! note
    The batch files are manually prepared in each input directory. For the cross-correlation stage, use `Utils/make_slurmbatch_parallel.jl` to prepare the slurm batch files to parallelize cc process with time chunks.

3. Run `sh Utils/smstats_seismonitoring.sh` to compile the outputs into csv table.

!!! note
    The stacked CorrData has the measurements in its misc (`C.misc`). `run_smstats.jl` gathers the measurements from stacked corrdata and output in csv table for post processing.

## Development environments
We conducted the case study of the ambient seismic noise processing using [TACC FRONTERA](https://frontera-portal.tacc.utexas.edu) and the local workstation (48cores) installed in [UW Denolle Lab](https://denolle-lab.github.io).

>Reference of FRONTERA: Dan Stanzione, John West, R. Todd Evans, Tommy Minyard, Omar Ghattas, and Dhabaleswar K. Panda. 2020. Frontera: The Evolution of Leadership Computing at the National Science Foundation. In Practice and Experience in Advanced Research Computing (PEARC ’20), July 26–30, 2020, Portland, OR, USA. ACM, New York, NY, USA, 11 pages. https://doi.org/10.1145/3311790.3396656

We also used the [FASRC Cannon cluster](https://www.rc.fas.harvard.edu/about/cluster-architecture/) supported by the FAS Division of Science Research Computing Group at Harvard University for the early development of the software tools.

We used the seismic data operated by the [High Resolution Seismic Network (HRSN)](https://ncedc.org/hrsn/) doi:[10.7932/HRSN](https://ncedc.org/bp_doi_metadata.html).
