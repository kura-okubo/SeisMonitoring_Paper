# Script to compute spectrogram on BP network using autocorrelation
#2022/08/16 Kurama Okubo
#2023/04/14 Update to dump the data

using SeisIO, SeisNoise #SeisMonitoring
using DSP, Dates, ScanDir, JLD2
using Plots

inputdatadir = "../data"
fodir = "../PPSD_data"
figdir = "../figure"

!ispath(fodir) && mkpath(fodir)
!ispath(figdir) && mkpath(figdir)
# load Autocorrlation

network = "BP"
station_list = ["CCRB", "EADB", "FROB", "GHIB", "JCNB", "JCSB", "LCCB", "MMNB", "RMNB", "SCYB", "SMNB", "VARB", "VCAB"]
channel_list = ["11", "22", "33"]
freqkey = "0.001-10.0"

for station in station_list
	for channel in channel_list
		netstachan_auto = "$(network).$(station)-$(network).$(station)-$(channel)"
		finame = "$(inputdatadir)/$(netstachan_auto).jld2"
		tukey_alpha=0.05

		# read first corrdata to read meta data

		t = jldopen(finame, "r")
		tkeys = keys(t)
		timekey = tkeys[1]
		C1 = t[timekey][freqkey]
		Ndata = trunc(Int, C1.cc_len*C1.fs) # data length used to compute the auto correlations
		Nlag = size(C1.corr, 1) # length of time lag of autocorrelations
		fs = C1.fs
		close(t)

		# initialize arrays
		tvec_all = []
		Sp_all = zeros((trunc(Int, (Nlag-1)/2 + 1), length(tkeys)))

		t = jldopen(finame, "r")
		tkeys = keys(t)

		# loop to load Sp
		for (i, key) in enumerate(tkeys)

			# push the cc time into the time vector
			st, et = split(key, "--")
			st, et = Dates.DateTime.([st, et])
			mt = st + Dates.Millisecond((et-st)/2)
			push!(tvec_all, mt)

			# load corrdata
			C = t[key][freqkey]


			xcorr = C.corr
			xcorr .*= DSP.tukey(Nlag, tukey_alpha) # apply tukey window
			xcorr ./= Ndata # NOTE: the scaling is done with the Ndata, not Nlag by theory.

			# 4. shift the xcorr using fft shift to make the midpoint (n/2 or n-1/2) to be zero to avoid the flip of sign.
			xcorr_shifted = DSP.fftshift(xcorr)

			# compute rfft and scale with sampling rate
			Sp = DSP.rfft(xcorr_shifted)
			Spfreq = DSP.rfftfreq(Nlag, C.fs)
			Sp *= 2.0/C.fs # 2.0 is applied to preserve total power from the negative side


			waterlevel_PSD = 1e-20 # apply the waterlevel where the value is less than the waterlevel

			# apply waterlevel to remove negative value due to numerical error
			inds = findall(x -> x < waterlevel_PSD, real(Sp)[:, 1]) # apply waterlevel to remove negative values due to numerical error in FFT
			Sp[inds] .= waterlevel_PSD + 0im
			Sp_all[:, i] = real(Sp)
		end

		close(t)

		# Plot periodgram
		Spfreq = DSP.rfftfreq(Nlag, fs)

		ylimit = [0.1, 4.0]
		yscale = :ln

		p = heatmap(tvec_all, Spfreq[2:end], DSP.Util.pow2db.(Sp_all[2:end, :]), ylabel="Frequency [Hz]",
		# p = heatmap(10*log10.(Sp_all), ylabel="Frequency [Hz]",
				 levels=100, colorbar=true, colorbar_title="PSD [(m/s)²/Hz] [dB]", framestyle = :box,
				 yscale=:identity , clim=(-180, -120), title="$(netstachan_auto)", xrotation = -45,
				 left_margin = 5Plots.mm,
				 right_margin = 5Plots.mm,
				 bottom_margin = 5Plots.mm,)

		# overwrite xticks
		xtickslist =  [Dates.DateTime(2002+i*2, 1, 1) for i in 0:10]
		xtickslabellist = Dates.format.(xtickslist,"yyyy-mm-dd");
		plot!(xtick=(xtickslist, xtickslabellist))

		# set fonts
		plot!(titlefont=font(12, "Arial"), tickfont=font(8, "Arial"), guidfont=font(8, "Arial"),
		 colorbar_titlefont=font(8, "Arial"), plot_titlefont=font(8, "Arial"))

		xlims!((Dates.DateTime(2002, 1, 1), Dates.DateTime(2022, 6, 1)))
		ylims!((0.1, 2.0))

		# plot hlines for frequency bands
		hl = hline!([0.9, 1.2], lw=1.0, ls=:dash, c="white", label="")

		# vlines for earthquakes
		vlines = [Dates.DateTime(2003, 12, 12), Dates.DateTime(2004, 9, 28), Dates.DateTime(2014, 8, 24)]
		vl = vline!(vlines, lw=1.5, ls=:dot, c="white", label="")

		p = plot!(size=(1000,500))

		figname = joinpath(figdir, "$(netstachan_auto).png")
		savefig(p, figname)

		# dump the data
		jldopen("$(fodir)/PPSDdata_$(netstachan_auto).jld2", "w") do fo
			fo["netstachan"] = netstachan_auto
			fo["freqkey"] = freqkey
			fo["fs"] = fs
			fo["tvec_all"] = tvec_all
			fo["Spfreq"] = Spfreq
			fo["Sp_all"] = Sp_all
		end
	end
end
# # save figure
# fmt = "png"
# figname = joinpath(figdir, "$(netstachan_auto)")*".$(fmt)"
# Plots.savefig(p, figname)
