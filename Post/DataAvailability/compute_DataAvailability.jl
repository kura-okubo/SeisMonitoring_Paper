# Script to compute PPSD using SeisMonitoring.compute_psdpdf
using Distributed
@everywhere using SeisMonitoring, Dates, DataFrames

datatype = "rawseismicdata" # choose "rawseismicdata" or "seisremoveeq"

fidir = "$(HOME)/ex_download_data_uwbackup_OUTPUT/seismicdata/"*datatype
fodir = "./Parkfield/DataAvailability_BP/output_csv"
!ispath(fodir) && mkpath(fodir)
foname = joinpath(fodir, "dataavailability_"*datatype)

starttime = DateTime(2002, 1, 1)
endtime   = DateTime(2022, 6, 1)

smstats_dataavailability(fidir,foname, starttime, endtime)
