using SeisMonitoring

# This script initiate project
project_name = "ex_cc_raw"
project_inputdir="./"
#project_outputdir="./"
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
set_parameter(fo_mainparam, "cc_RawData_path",  "/scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_removeeq_raw_OUTPUT/seismicdata/seisremoveeq")
set_parameter(fo_mainparam, "cc_normalization",  "none")
set_parameter(fo_mainparam, "corr_type",  "CC")
set_parameter(fo_mainparam, "pairs_option",  "all")
set_parameter(fo_mainparam, "chanpair_type",  "all")
set_parameter(fo_mainparam, "data_contents_fraction",  "0.5")
set_parameter(fo_mainparam, "IsOnebit",  "false")
set_parameter(fo_mainparam, "smoothing_windowlength",  "7")
set_parameter(fo_mainparam, "cc_bpfilt_method",  "Wavelet")
