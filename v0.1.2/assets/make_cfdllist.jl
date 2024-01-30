using DataFrames, CSV

df = DataFrame(CSV.File("correlations_list.txt", header=0))
stchanpairs_list = df.Column6

# reformat the station pairs

stpair_list = []
for stchanpair in stchanpairs_list
	st1, st2 = split(split(stchanpair, ".jld2")[1], "-")
	stpair = st1*"-"*st2
	push!(stpair_list, stpair)
end
unique!(stpair_list)

# write the list of options

open("./cfdl_optionlist.txt", "w") do file
	for stpair in stpair_list
	   write(file, "<option value=\"$(stpair)\">$(stpair)</option>\n")
	end
end
