#using ClusterManagers
using Distributed

#=======================================#
#This script adds procs with proper nodes assigned by machine file,
# and run the SeisMonitoring.jl
#
# USAGE:
# julia multinode_sm_slurm_run.jl $NUMOFPROCS $MACHIEFILEPATH
# e.g.
# julia multinode_sm_slurm_run.jl 560 ./nodes.1300678
#=======================================#

# parse host name from machine file
nprocesses = parse(Int, ARGS[1])
# machinefile = ARGS[2]
# machinelist = unique(readlines(machinefile))
# N = length(machinelist)
# procspernode = round(Int, nprocesses/N)
# addproceslist = []
# for machine in machinelist
#     push!(addproceslist, (machine, procspernode))
# end

#println(addproceslist)
#Distributed.addprocs(addproceslist, tunnel=true, max_parallel=500, topology=:master_worker)
Distributed.addprocs(nprocesses)

@show nprocs()
@everywhere using SeisMonitoring

#println("test multinode done!")
SeisMonitoring.run_job("/Users/kokubo/Dropbox/NIED_RESEARCH/SeisMonitoring_Paper/Appx/tremorsignal/seisremoveeq_demo/ex_download_data_removaldemo_INPUT/mainparam.jl", run_seisdownload=true,
        run_seisremoveeq=true,
        run_seisxcorrelation=false,
        run_seisstack=false)
