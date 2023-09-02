using SeisIO, SeisNoise, JLD2

t = jldopen("/Users/kokubo/Dropbox/NIED_RESEARCH/SeisMonitoring_Paper/Appx/plot_CCF/data/BP.EADB-BP.LCCB-11.jld2", "r")
C = t["2002-09-01T00:00:00--2002-09-02T00:00:00/0.9-1.2"]
C
