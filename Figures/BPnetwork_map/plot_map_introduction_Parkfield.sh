#!/bin/bash

# Reference: https://estuarine.jp/2017/11/gmt-5-map-frame-b/ (2022/09/27)

gmt gmtset MAP_FRAME_TYPE = plain
gmt gmtset FORMAT_GEO_MAP = D
gmt gmtset MAP_SCALE_HEIGHT = 0.3

# range=-121.1/-119.85/35.35/36.6
range=-121.15/-119.85/35.35/36.5
insetrange=-125/-117.0/32.5/40

size=12
insetsize=4

oceancolor=0/140/201
stationcolor=249/214/17
ssecolor=49/120/250
# sanandreascolor=201/73/37
sanandreascolor=black
rupturecolor=211/73/37
hypocolor=255/73/37
scale=g-120.6/35.43+c36.0+w30+f+l"km"
insetscale=g-123/34.5+c36.0+w100+l"km"

#---write file of study area---#
minx="$(cut -d'/' -f1 <<< ${range})"
maxx="$(cut -d'/' -f2 <<< ${range})"
miny="$(cut -d'/' -f3 <<< ${range})"
maxy="$(cut -d'/' -f4 <<< ${range})"

echo "${minx} ${miny}" > studyarea.txt
echo "${minx} ${maxy}" >> studyarea.txt
echo "${maxx} ${maxy}" >> studyarea.txt
echo "${maxx} ${miny}" >> studyarea.txt
echo "${minx} ${miny}" >> studyarea.txt

#------------------------------#


boxlinecolor=black

cptfile="GMT_graywhite.cpt"

gmt begin map_parkfield eps

	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE+t"Parkfield" -Xc -Yc 

	#plot topography
	for finame in grdn36w119 grdn36w120 grdn36w121 grdn36w122 grdn37w119 grdn37w120 grdn37w121 grdn37w122; do
		gmt grdimage ${finame}.grd -JM${size} -R${range} -C${cptfile} -I
	done

	gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -S${oceancolor} -L${scale}
	gmt psxy historicalfaults.txt -JM${size} -R${range} -W2.0,${sanandreascolor}
	gmt psxy gmt_shelly2017ssefamily.txt -JM${size} -R${range} -Sc0.2 -W1.0,0-0-0 -G${ssecolor}
	# Plot Parkfeild rupture zone
	gmt psxy parkfield_rupture.txt -JM${size} -R${range} -W.5,red -G${rupturecolor}
	gmt psxy sansimeon_rupture.txt -JM${size} -R${range} -W1.,black,- 
	gmt psxy gmt_BPnetwork.txt -JM${size} -R${range} -St0.4 -W1.0,0-0-0 -G${stationcolor}
	gmt psxy parkfield_hypo.txt -JM${size} -R${range} -Sa0.5 -W.5,black -G${hypocolor}
	gmt psxy sansimeon_hypo.txt -JM${size} -R${range} -Sa0.5 -W.5,black -G${hypocolor}
	# gmt psxy villages.txt -JM${size} -R${range} -Ss0.3 -W.5,0-0-0 -Ggray

	# inset of california
	gmt inset begin -DjTR+w4/4.6 -F+gwhite+p0.7
		gmt coast -JM${insetsize} -R${insetrange} -A200 -N2 -Dh -W1.0p,black  -L${insetscale}
		gmt psxy historicalfaults.txt -JM${insetsize} -R${insetrange} -W1.0,${sanandreascolor}
		gmt psxy quaternaryfaults.txt -JM${insetsize} -R${insetrange} -W1.0,${sanandreascolor}
		gmt psxy studyarea.txt -JM${insetsize} -R${insetrange} -W.5,${boxlinecolor}
		gmt psxy cities_inset.txt -JM${insetsize} -R${insetrange} -Ss0.2 -W.5,0-0-0 -Ggray
		gmt psxy inset_hypo.txt -JM${insetsize} -R${insetrange} -Sa0.3 -W.5,black -Gblack

	gmt inset end

gmt end show
