using LightXML, DelimitedFiles, JLD2

# This script converts kml from https://usgs.maps.arcgis.com/apps/webappviewer/index.html
# to lon, lat coordinates at Parkfield
# last access: 2022.03.28 https://usgs.maps.arcgis.com/apps/webappviewer/index.html?id=5a6038b3a1684561a9b0aadf88412fcf

# We donwloaded qfaults.kmz from https://earthquake.usgs.gov/static/lfs/nshm/qfaults/qfaults.kmz,
# Then open it with Google Earth Pro. We extracted the trace of historical faults only, and save it as "historicalfaults.kml".

xdoc = parse_file("historicalfaults.kml");

xroot = root(xdoc);

ces = collect(child_elements(xroot));

e1 = ces[1]["Folder"][1]["Placemark"];
numoftrace = length(e1);

sanandreasid = []
for i = 1:length(e1);

    d1 = e1[i]["description"]
    if occursin("San Andreas", content(d1[1]))
        println(content(d1[1]))
        push!(sanandreasid, i)
    end
end

# extract traces

fault = []
for i = sanandreasid
    str1 = content(e1[i]["MultiGeometry"][1]["LineString"][1]["coordinates"][1])
    str2 = replace(replace(str1, "\n" => ""), "\t"=>"")
    str3 = split.(split(str2, " "), ",")

    coord = []
    for j = 1:length(str3)

        try str4 = parse.(Float64, str3[j])
            push!(coord, str4)

        catch
            continue;
            #it's empty at last due to split
        end
    end
    push!(fault, coord)
end

io = open("historicalfaults.txt", "w")
for segments in fault
    xy = []
    for segment in segments
        push!(xy, segment[1:2])
    end
    writedlm(io, xy)
    write(io, ">\n")
end
close(io)

# #save as jld2
# jldopen("sanandreasfault.jld2", "w") do file
#     file["originaldatabase"]     = "qfaults.kmz";
#     file["fault"] = fault;
# end

#----------------------------------------------------------------------#

# xdoc = parse_file("quaternaryfaults.kml");

# xroot = root(xdoc);

# ces = collect(child_elements(xroot));

# e1 = ces[1]["Folder"][1]["Placemark"];
# numoftrace = length(e1);

# sanandreasid = []
# for i = 1:length(e1);

#     d1 = e1[i]["description"]
#     if occursin("San Andreas", content(d1[1]))
#         println(content(d1[1]))
#         push!(sanandreasid, i)
#     end
# end

# # extract traces

# fault = []
# for i = sanandreasid
#     str1 = content(e1[i]["MultiGeometry"][1]["LineString"][1]["coordinates"][1])
#     str2 = replace(replace(str1, "\n" => ""), "\t"=>"")
#     str3 = split.(split(str2, " "), ",")

#     coord = []
#     for j = 1:length(str3)

#         try str4 = parse.(Float64, str3[j])
#             push!(coord, str4)

#         catch
#             continue;
#             #it's empty at last due to split
#         end
#     end
#     push!(fault, coord)
# end

# io = open("quaternaryfaults.txt", "w")
# for segments in fault
#     xy = []
#     for segment in segments
#         push!(xy, segment[1:2])
#     end
#     writedlm(io, xy)
#     write(io, ">\n")
# end
# close(io)
