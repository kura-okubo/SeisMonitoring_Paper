using SeisMonitoring

# This script initiate project
project_name = "ex_download_data_removaldemo"
project_inputdir="./"
project_outputdir="./"

master_param="./mainparam_removaldemo.jl"

# make default input and output directory
init_project(project_name=project_name,
             project_inputdir=project_inputdir, # local directory
             project_outputdir=project_outputdir,
             force=true, gui=false # external HDD
            )


# make request station list
fipath = "./BP_gmap-stations_removaldemo.txt"

locchan = Dict(
            "BP" => [("*", "SP*")]
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



