using SeisMonitoring

# This script initiate project
project_name = "ex_stack_raw_2010-2020_stretching"
project_inputdir="./"
# project_outputdir="./"
project_outputdir="/scratch1/07208/kokubo09/SeisMonitoring_Paper"

master_param="./mainparam_master.jl"

# make default input and output directory
init_project(project_name=project_name,
             project_inputdir=project_inputdir, # local directory
             project_outputdir=project_outputdir,
             force=true, gui=false # external HDD
            )

# make request station list
fipath = "./BP_gmap-stations.txt"

locchan = Dict(
            "BP" => [("*", "BP*"), ("*", "SP*")]
            )

station_fodir = project_outputdir*"/$(project_name)_OUTPUT"
station_path = make_requeststation_fromIRISgmap(fipath, locchan=locchan, fodir=station_fodir, foname="$(project_name).jld2")


# copy master parameter file into project directory
fo_mainparam = project_inputdir*"/$(project_name)_INPUT/mainparam.jl"
cp(master_param, fo_mainparam)

# replace parameters for casestudy
set_parameter(fo_mainparam, "project_name", project_name)
set_parameter(fo_mainparam, "project_inputdir", project_inputdir*"/$(project_name)_INPUT")
set_parameter(fo_mainparam, "project_outputdir", project_outputdir*"/$(project_name)_OUTPUT")
set_parameter(fo_mainparam, "requeststation_file",  station_fodir*"/$(project_name).jld2")
# the rest of parameters should be modified case by case.
set_parameter(fo_mainparam, "stack_RawData_dir",  "/scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_raw_OUTPUT/cc")
set_parameter(fo_mainparam, "stack_method",  "selective")
set_parameter(fo_mainparam, "collect_stationpairs",  "false")
set_parameter(fo_mainparam, "compute_reference",  "true")
set_parameter(fo_mainparam, "compute_shorttimestack",  "true")
set_parameter(fo_mainparam, "reference_starttime",  "2010-01-01T00:00:00")
set_parameter(fo_mainparam, "reference_endtime",  "2020-01-01T00:00:00")
set_parameter(fo_mainparam, "keep_corrtrace",  "false")
set_parameter(fo_mainparam, "stretch_debugplot",  "true")
set_parameter(fo_mainparam, "measurement_method",  "compute_dvvdqq")
set_parameter(fo_mainparam, "dvv_stretching_range",  "0.02")
set_parameter(fo_mainparam, "dvv_stretching_Ntrial",  "201")
set_parameter(fo_mainparam, "geometricalspreading_α",  "0.5")
set_parameter(fo_mainparam, "computedqq_smoothing_half_win",  "10")
