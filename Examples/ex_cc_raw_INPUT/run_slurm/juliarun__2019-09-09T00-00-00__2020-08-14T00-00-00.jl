using Distributed
@show Threads.nthreads()
@show nprocs()
@everywhere using SeisMonitoring
SeisMonitoring.run_job("/home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_raw_INPUT/run_slurm/mainparam__2019-09-09T00-00-00__2020-08-14T00-00-00.jl", run_seisdownload=false,
    run_seisremoveeq=false,
    run_seisxcorrelation=true,
    run_seisstack=false)