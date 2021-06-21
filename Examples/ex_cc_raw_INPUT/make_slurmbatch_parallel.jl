using Dates
using SeisMonitoring: parse_inputdict, set_parameter

function make_slurm_script_pmap(
        fipath::String,
        jl_batch::String,
        partition::String="normal",
        totalnodes::Int=1,
        totaltasks::Int=56,
        runtime::String="02:00:00"; # write in slurm format
        absolute_juliapath::String="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia" # please find this by type `which julia` in bash shell

)

    ispath(fipath) ? include(fipath) : error("$(fipath) not found.")
    InputDict_parsed = parse_inputdict(InputDict)
    project_name = InputDict_parsed["project_name"]
    project_inputdir  = InputDict_parsed["project_inputdir"]
    project_outputdir = InputDict_parsed["project_outputdir"]

    batchdir, batchname = splitdir(jl_batch)
    jl_batch_name=batchname[1:end-3]
    _, st, et = split(jl_batch_name, "__")

    st_str = replace(string(st), ":" => "-")
    et_str = replace(string(et), ":" => "-")

    slurm_batch =  joinpath(batchdir, "slurmrun__$(st_str)__$(et_str).slurm")

    out = joinpath(project_outputdir, "out_$(project_name)_%j__$(st_str)__$(et_str).txt")
    err = joinpath(project_outputdir, "err_$(project_name)_%j__$(st_str)__$(et_str).txt")

    fo = open(slurm_batch, "w")
    write(fo, "#!/bin/bash\n#----------------------------------------------------\n")
    write(fo, "#SBATCH -p $(partition)\n")
    write(fo, "#SBATCH -J $(project_name)__$(st_str)__$(et_str)\n")
    write(fo, "#SBATCH -N $(totalnodes)\n")
    write(fo, "#SBATCH -n $(totaltasks)\n")
    write(fo, "#SBATCH -t $(runtime)\n")
    write(fo, "#SBATCH -o $(out)\n")
    write(fo, "#SBATCH -e $(err)\n")
    write(fo, "#----------------------------------------------------\n\n")

    write(fo, "date\n")
    # Thread parallelization
    # write(fo, "export JULIA_NUM_THREADS=$(totaltasks)\n")
    # write(fo, "module purge\n")
    write(fo, "execstart=`date +%s`\n")
    write(fo, "$(absolute_juliapath) -p $(totaltasks) $(jl_batch)\n")
    # write(fo, "module load remora\n")
    # write(fo, "remora $(absolute_juliapath) $(jl_batch)\n")
    write(fo, "execend=`date +%s`\n")
    write(fo, "runtime=\$((execend-execstart))\n")
    #output execution time of this job
    fo_executionfile = joinpath(project_outputdir, "exectime_$(project_name)__$(st_str)__$(et_str).txt")
    write(fo, "echo \$runtime > $(fo_executionfile)\n")
    write(fo, "date\n")
    write(fo, "echo \"job $(project_name)__$(st)__$(et) is successfully done.\"")
    close(fo)

    return slurm_batch

end

function make_julia_script_pmap(fipath::String)

    fidir, finame = splitdir(fipath)
    _, st, et = split(split(finame, ".")[1], "__")

    st_str = replace(string(st), ":" => "-")
    et_str = replace(string(et), ":" => "-")
    jl_batch = joinpath(fidir, "juliarun__$(st_str)__$(et_str).jl")
    fo = open(jl_batch, "w")

    # parse host name from machine file
    # nprocesses = parse(Int, ARGS[1])
    # # nprocesses = 560
    # machinefile = ARGS[2]
    # # machinefile = "./nodes.1300678"
    # machinelist = unique(readlines(machinefile))
    # N = length(machinelist)
    # procspernode = round(Int, nprocesses/N)
    # addproceslist = []
    # for machine in machinelist
    #     push!(addproceslist, (machine, procspernode))
    # end

    # #println(addproceslist)
    # Distributed.addprocs(addproceslist, tunnel=true, max_parallel=500, topology=:master_worker)
    # #using ClusterManager.jl
    # #addprocs_slurm(nprocesses, max_parallel=500)
    #
    # write(fo, "@show nprocs()\n")
    write(fo, "using Distributed\n")
    write(fo, "@show Threads.nthreads()\n")
    write(fo, "@show nprocs()\n")
    #
    write(fo, "@everywhere using SeisMonitoring\n")
    #
    write(fo, "SeisMonitoring.run_job(\"$(fipath)\", run_seisdownload=false,
    run_seisremoveeq=false,
    run_seisxcorrelation=true,
    run_seisstack=false)")
    close(fo)
    return jl_batch
end

function make_pmap_runall(output_dir::String)

    fo = open(joinpath(output_dir, "run_all.sh"), "w")

    write(fo, "#!/bin/bash\n")
    write(fo, "for file in $(output_dir)/*.slurm; do\n")
    write(fo, "  echo \$file\n")
    write(fo, "  sbatch \$file\n")
    write(fo, "  #time sh \$file\n") # LOCAL DEBUG
    write(fo, "done\n")
    close(fo)

end

function make_pmapparalleljobs(inputfile_origin::String, starttime::DateTime, endtime::DateTime,
    N_node::Int, Ntasks_per_node::Int, time_unit::Real;
    output_dir::String="./run_slurm",
    absolute_juliapath::String="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia", # please find this by type `which julia` in bash shell
    partition::String="normal",
    runtime::String="02:00:00" # write in slurm format
    )


    !ispath(output_dir) && mkpath(output_dir)

    #compute combination of start and endtime with N_node
    if mod(Second(endtime-starttime).value,  time_unit) != 0
        error("total process time is not divided by time_unit.")
    end

    total_time_unit = Int(Second(endtime-starttime).value/time_unit)

    time_chunk = floor(Int, total_time_unit/N_node)

    st_list, et_list = DateTime[], DateTime[]
    for i in collect(Iterators.partition(1:total_time_unit, time_chunk))
        stid, etid = i[1], i[end]
        st = starttime + Second((stid-1)*time_unit)
        et = st + Second((etid-stid+1)*time_unit)
        push!(st_list,st)
        push!(et_list,et)
        println((st, et))
    end

    # copy original mainparam.jl
    slurmfile_list = String[]
    for i in 1:length(st_list)
        st_chunk = st_list[i]
        et_chunk = et_list[i]

 	st_str = replace(string(st_chunk), ":" => "-")
        et_str = replace(string(et_chunk), ":" => "-")

        finame_origin = split(splitdir(inputfile_origin)[2], ".")[end-1]
        fipath =joinpath(output_dir, join([finame_origin, "$(st_str)", "$(et_str)"], "__")*".jl")
        cp(inputfile_origin, fipath, force=true)
        # set start and end time
        set_parameter(fipath, "starttime", st_chunk)
        set_parameter(fipath, "endtime", et_chunk)

        # make julia script to run job
        jl_batch = make_julia_script_pmap(fipath)

        # make slurm batch script to submit job
        slurm_batch = make_slurm_script_pmap(fipath, jl_batch, partition, 1, Ntasks_per_node,
        runtime, absolute_juliapath=absolute_juliapath)

        push!(slurmfile_list, slurm_batch)
    end

    # make bash script to submit all jobs
    make_pmap_runall(output_dir)

    @info("$(output_dir) is successfully made. Please exit julia, and type shell command:
    `sh $(output_dir)/run_all.sh`.")

end

#===Inpute Parameters===#
starttime = DateTime(2002,1,1)
endtime = DateTime(2020,9,1)

N_node = 20
Ntasks_per_node=36
time_unit = 86400
output_dir = "/home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_raw_INPUT/run_slurm"
inputfile_origin = "/home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_raw_INPUT/mainparam.jl"

# absolute_juliapath="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"
absolute_juliapath="/home1/07208/kokubo09/packages/julia-1.5.3/bin/julia" # please find this by type `which julia` in bash shell
partition="small"
runtime="2:00:00"
#========================#
make_pmapparalleljobs(inputfile_origin, starttime, endtime,
   N_node, Ntasks_per_node, time_unit,
   output_dir=output_dir,
   absolute_juliapath=absolute_juliapath, # please find this by type `which julia` in bash shell
   partition=partition,
   runtime=runtime; # write in slurm format
   )
