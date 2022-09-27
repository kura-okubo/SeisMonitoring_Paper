# @everywhere using SeisMonitoring, Dates
using SeisMonitoring, Dates
shorttimestackdir = string(ARGS[1]) #"/Users/kokubo/Documents/research/ex_stack_raw_2010-2020_mwcs_OUTPUT/shorttime"
fodir = string(ARGS[2])#"/Users/kokubo/Documents/research/ex_stack_raw_2010-2020_mwcs_OUTPUT/"
starttime=DateTime("2002-1-1")
endtime=DateTime("2022-6-1")
println("Start processing $(shorttimestackdir) $(fodir)")
if string(ARGS[3]) == "stretching"
	smstats_read_stretching(shorttimestackdir, fodir, starttime, endtime, foname=string(ARGS[4]))
elseif string(ARGS[3]) == "mwcs"
	smstats_read_mwcs(shorttimestackdir, fodir, starttime, endtime, foname=string(ARGS[4]))
elseif string(ARGS[3]) == "dvvdqq"
	smstats_read_computedvvdqq(shorttimestackdir, fodir, starttime, endtime, foname=string(ARGS[4]))
end   

