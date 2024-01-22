#!/bin/bash

# Reference: https://estuarine.jp/2017/11/gmt-5-map-frame-b/ (2022/09/27)
# 2023.4.16 update to plot local map associated with BP network

gmt gmtset MAP_FRAME_TYPE = plain
gmt gmtset FORMAT_GEO_MAP = D
gmt gmtset MAP_SCALE_HEIGHT = 0.5

range=-120.61/-120.3/35.8/36.05

size=12

stationcolor=249/214/17
ssecolor=49/120/250
# sanandreascolor=201/73/37
sanandreascolor=black
rupturecolor=211/73/37
hypocolor=255/73/37
scale=g-120.51/35.82+c36.0+w10k+f+l"km"

#---write file of study area---#
minx="$(cut -d'/' -f1 <<< ${range})"
maxx="$(cut -d'/' -f2 <<< ${range})"
miny="$(cut -d'/' -f3 <<< ${range})"
maxy="$(cut -d'/' -f4 <<< ${range})"

echo "${minx} ${miny}" > studyarea_local.txt
echo "${minx} ${maxy}" >> studyarea_local.txt
echo "${maxx} ${maxy}" >> studyarea_local.txt
echo "${maxx} ${miny}" >> studyarea_local.txt
echo "${minx} ${miny}" >> studyarea_local.txt

#------------------------------#


boxlinecolor=black

gmt begin map_BPnetwork_local eps

	gmt basemap -JM${size} -R${range} -Ba.1f0.1 -BWSNE -L${scale} -Xc -Yc 

	# gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -S${oceancolor} -L${scale}
	gmt psxy historicalfaults.txt -JM${size} -R${range} -W1.0,${sanandreascolor}

	# gmt psxy gmt_shelly2017ssefamily.txt -JM${size} -R${range} -Sc0.2 -W1.0,0-0-0 -G${ssecolor}
	# Plot Parkfeild rupture zone
	# gmt psxy parkfield_rupture.txt -JM${size} -R${range} -W.5,red -G${rupturecolor}
	# gmt psxy sansimeon_rupture.txt -JM${size} -R${range} -W1.,black,- 
	gmt psxy gmt_BPnetwork.txt -JM${size} -R${range} -St0.35 -W1.0,0-0-0 -G${stationcolor}

	# plot approximated fault line to compute fault normal distance
	gmt psxy approx_faultloc.txt -JM${size} -R${range} -W1.0,"blue",-
	gmt psxy approx_faultloc.txt -JM${size} -R${range} -Sc0.2 -W1.0,0-0-0 -Gblue

	gmt pstext gmt_BPnetwork.txt -JM${size} -R${range} -F+f8p,Helvetica -D13p/7p
	# gmt psxy parkfield_hypo.txt -JM${size} -R${range} -Sa0.5 -W.5,black -G${hypocolor}
	# gmt psxy sansimeon_hypo.txt -JM${size} -R${range} -Sa0.5 -W.5,black -G${hypocolor}
	# gmt psxy villages.txt -JM${size} -R${range} -Ss0.3 -W.5,0-0-0 -Ggray

gmt end show
