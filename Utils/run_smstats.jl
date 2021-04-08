# @everywhere using SeisMonitoring, Dates
using SeisMonitoring, Dates
shorttimestackdir = string(ARGS[1]) #"/Users/kokubo/Documents/research/ex_stack_raw_2010-2020_mwcs_OUTPUT/shorttime"
fodir = string(ARGS[2])#"/Users/kokubo/Documents/research/ex_stack_raw_2010-2020_mwcs_OUTPUT/"
starttime=DateTime("2002-1-1")
endtime=DateTime("2020-1-1")
println("Start processing $(shorttimestackdir) $(fodir)")
smstats_read_mwcs(shorttimestackdir, fodir, starttime, endtime, foname="${ARGS[3]}")
