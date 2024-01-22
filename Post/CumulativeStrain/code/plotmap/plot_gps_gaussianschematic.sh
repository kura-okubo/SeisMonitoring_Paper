#This script plots the schematic map of BP network and GPS stations

mkdir -p ../../figure/plotmap
gmt gmtset MAP_FRAME_TYPE = plain # ref:https://estuarine.jp/2017/11/gmt-5-map-frame-b/
gmt gmtset FORMAT_GEO_MAP = D # F means attaching E/W and N/S
gmt gmtset MAP_SCALE_HEIGHT = 0.5
gmt gmtset COLOR_NAN 100/100/100


# plot background map
size=12
gpssize=0.18

hypocolor=255/73/37
stationcolor=249/214/17
oceancolor=white #0/140/201
edgecolor=2/158/115
sanandreascolor=black
gaussiancirclecolor=black #213/94/0

header=1

maxlon=-120.26 #-119.5
minlon=-120.68 #-121.4
maxlat=36.1 #36.6
minlat=35.75 #35.4

# range=-120.61/-120.3/35.8/36.05

range=${minlon}/${maxlon}/${minlat}/${maxlat}
scale=g-120.6/35.78+c36.0+w10+l"km"+f


edgefile=../../data/triangular_edges.xy   	   # triangular edge file
GPSsitefile=../../data/BP_GPSstations_GMT.xy   # GPS location file
gaussiancirclefile=../../data/BP_gaussianregion.txt 

gmt begin ../../figure/plotmap/BP_gaussianrange_schematic eps

	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE  -Xc -Yc

	# plot san andreas fault
	gmt psxy ../../data/historicalfaults.txt -JM${size} -R${range} -W1.0,${sanandreascolor}

	# plot triangular edges
	gmt plot ${edgefile} -JM${size} -R${range} -W0.2p+cl -Z -C${edgecolor} -t50

	# plot GPS stations and BP network
	gmt psxy ${GPSsitefile} -JM${size} -R${range} -Sr0.1 -G1/115/178 #-W0,0/0/200 
	# gmt psxy ../../data/gmt_BPnetwork.txt -JM${size} -R${range} -St0.2 -Gwhite -W1.0,0-0-0 

	# plot station name
	# gmt pstext ../../data/BP_GPSstations_GMT.xy -R${range} -JM${size} -F+f8p,Helvetica,-=0.5p,black+jLB  #plot site name

	# plot gaussian weighted circle
	gmt psxy ${gaussiancirclefile} -JM${size} -R${range} -SE- -W.2,${gaussiancirclecolor},-

	# plot BP seismic stations
	gmt psxy gmt_BPnetwork.txt -JM${size} -R${range} -St0.3 -W1.0,0-0-0 -G${stationcolor}

	# BP station name
	gmt pstext gmt_BPnetwork.txt -JM${size} -R${range} -F+f8p,Helvetica -D13p/7p

	# plot hypocenter of Parkfield earthquake
	gmt psxy parkfield_hypo.txt -JM${size} -R${range} -Sa0.35 -W.5,black -G${hypocolor}

	# plot scale on the top of figure
	gmt basemap -JM${size} -R${range} -L${scale} -Xc -Yc


gmt end show



