using SeisIO, SeisNoise, JLD2, Plots, Dates, ProgressMeter, Measures, ScanDir, NPZ
using SeisMonitoring: assemble_corrdata
using PyPlot
pyplot()

rc("font",family ="Arial",size=12)
rc("xtick", direction = "in")
rc("xtick.major", size = 5, width=0.5)
rc("xtick.minor", size = 2, width=1, visible=true)
rc("ytick", direction = "in")
rc("ytick.major", size = 5, width=0.5)
rc("ytick.minor", size = 2, width=1, visible=true)

fodir = "../figure"
!ispath(fodir) && mkpath(fodir)
!ispath(fodir*"/ccf_julia") && mkpath(fodir*"/ccf_julia")
!ispath(fodir*"/ref_julia") && mkpath(fodir*"/ref_julia")


#------------------------------------------#
CCF_datadir = "../data/"
starttime = DateTime("2002-01-01T00:00:00")
endtime = DateTime("2008-06-01T00:00:00")
refstartyear = DateTime("2002-01-01T00:00:00")
refendyear = DateTime("2022-06-01T00:00:00")

# endtime = DateTime("2022-06-01T00:00:00")
frequency_key = "0.9-1.2"

coda_init_factor = 2.0
max_coda_length = 40.0
min_ballistic_twin = 5.0
vel = 1.0 #[km/s]
maxlag_trim = 50.0 # trim the corrdata to optimize the data size

outdatadir = "../data_npz"
#------------------------------------------#
!ispath(outdatadir) && mkpath(outdatadir)

# Find all CCF/ACF files
ccfdata_path_all = String[]
for (root, dirs, files) in ScanDir.walkdir(CCF_datadir)
   for file in files
       fi = joinpath(root, file)
       (split(fi, ".")[end] == "jld2") && push!(ccfdata_path_all, fi)# filter if it is .seisio
   end
end


# fi_stachanpair = "BP.EADB-BP.LCCB-11"
Threads.@threads for fi_stachanpair in ccfdata_path_all
    # @show fi_stachanpair = ccfdata_path_all[1]
    println("start processing $(fi_stachanpair)")
    sta1, sta2, comp = split(split(split(fi_stachanpair, "/")[end], ".jld2")[1], "-")
    stachanpair = "$(sta1)-$(sta2)-$(comp)"
    fodataname = outdatadir*"/corrdata_$(stachanpair)_$(frequency_key).npz"
    if isfile(fodataname)
        println("$(fodataname) exists. continue.")
        continue
    end

    # read corrdata
    fi = jldopen("$(fi_stachanpair)", "r")

    Craw, CorrData_Buffer = assemble_corrdata(fi,starttime,endtime,frequency_key, MAX_MEM_USE=2.0)

    close(fi)

    # Assemble all corr data
    C = CorrData()
    C.corr = zeros(Float32, 4001, 0)

    @showprogress 1 "computing: " for key in sort(collect(keys(CorrData_Buffer)))
        if isempty(C.id)
            # initialize corrdata
            C = CorrData_Buffer[key]
            C.t = zeros(Float64, 0)
            C.corr = zeros(Float32, 4001, 0)
        end
        if isempty(CorrData_Buffer[key].t); continue; end
        C.corr = hcat(C.corr, CorrData_Buffer[key].corr)
        push!(C.t, CorrData_Buffer[key].t[1])
    end

    lags = -C.maxlag:1/C.fs:C.maxlag

    triminds = findall(x->((-maxlag_trim<=x) &(x<=maxlag_trim)), lags)
    lags_trim = lags[triminds]
    # times = Dates.format.(Dates.unix2datetime.(C.t),"yyyy/m")
    # Cstack = stack(C,allstack=true)

    # # Normalize with its max amplitude
    # abs_max!(C)
    #
    # yticks = 1:length(times)
    # yticklabels = times
    #
    # # find 1st time window of each year
    # ytickids = []
    # ystart = 2002
    # for i in yticks
    #     if ystart == parse(Int, split(yticklabels[i], "/")[1])
    #         push!(ytickids, i)
    #         ystart = ystart+1
    #     end
    # end

    if sta1==sta2
        #auto correlation
        ci = [-min_ballistic_twin, min_ballistic_twin]
    else
        ci = [-coda_init_factor*C.dist/vel, coda_init_factor*C.dist/vel]
    end
    ce = [-max_coda_length , max_coda_length]

    # Plots.heatmap(lags,yticks,C.corr',c=:balance,legend=:none, framestyle = :box, margin = 15mm,
    #     xlims = (-50, 50),
    #     yticks=(yticks[ytickids], yticklabels[ytickids]), title="$(Craw.name) $(frequency_key)Hz")
    #
    # vline!(ci, linestyle=:dash, linecolor=:black)
    # vline!(ce, linestyle=:dash, linecolor=:black)
    # plot!(size=(800,600), dpi=300)
    # xlabel!("Time lag [s]")
    # Plots.savefig(fodir*"/ccf_julia/ccf_$(Craw.name)_$(frequency_key)Hz.png")

    # plot reference
    # find 1st time window of each year
    yrefids = []
    for i in 1:length(C.t)
        tstamp = u2d(C.t[i])
        if (refstartyear <= tstamp) & (tstamp <= refendyear)
        # if 2010 < parse(Int, split(yticklabels[i], "/")[1]) & 2020 >= parse(Int, split(yticklabels[i], "/")[1])
            push!(yrefids, i)
        end
    end

    Cstack = deepcopy(C)
    Cstack.t = C.t[yrefids]
    Cstack.corr = C.corr[:, yrefids]

    if ~isempty(Cstack.corr)

        stack!(Cstack,allstack=true)

        # Plots.plot(lags, Cstack.corr, linecolor=:black, xlims=(-50, 50), ylims=(-1, 1), framestyle = :box, legend=false,
        #             title="$(C.id) $(frequency_key)Hz")
        # vline!(ci, linestyle=:dash, linecolor=:black)
        # vline!(ce, linestyle=:dash, linecolor=:black)
        #
        # plot!(size=(800,200), dpi=300)
        #
        # xlabel!("Time lag [s]")
        # Plots.savefig(fodir*"/ref_julia/ref_$(Craw.name)_$(frequency_key)Hz.png")
    end

    data_corr = Dict("lags" => lags_trim, "t"=>C.t, "corr"=>C.corr[triminds, :], "linstack"=>Cstack.corr[triminds], "codainit"=>ci, "codaend"=>ce,
                     "coda_init_factor"=>coda_init_factor, "max_coda_length"=>max_coda_length, "vel"=>vel)

    save(fodataname, data_corr)
end
