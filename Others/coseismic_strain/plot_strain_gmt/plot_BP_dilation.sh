#This script plots dilation computed with coulomb33 at Parkfield
gmt gmtset MAP_FRAME_TYPE = plain # ref:https://estuarine.jp/2017/11/gmt-5-map-frame-b/
gmt gmtset FORMAT_GEO_MAP = D # F means attaching E/W and N/S
gmt gmtset MAP_SCALE_HEIGHT = 0.25
gmt gmtset COLOR_NAN 110/110/110
gmt gmtset FONT_TITLE 13p,Helvetica,black
# plot background map
size=7
gpssize=0.06
safodsize=0.16

oceancolor=white #0/140/201

hypocolor=255/73/37
stationcolor=0/25/200
oceancolor=white #0/140/201
# edgecolor=2/158/115
sanandreascolor=black
crosssectioncolor=yellow2
safodcolor=green4
rupturecolor=211/73/37
hypocolor=255/73/37

maxlon=-120.2 #-119.5
minlon=-120.8 #-121.4
maxlat=36.2 #36.6
minlat=35.7 #35.4

range=${minlon}/${maxlon}/${minlat}/${maxlat}
scale=g-120.65/35.755+c36.0+w20+l"km"+f


# edgefile=../../data/triangular_edges.xy   	   # triangular edge file
# GPSsitefile=../../data/BP_GPSstations_GMT.xy   # GPS location file
grdfile=./BP_StrainChange_dilation.xyz.grd
safodfile=./SAFOD_location.txt

python makecpt_py.py 20,250 -4 4 0.01 0 true t_d.cpt

gmt begin BP_dilation eps

	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE+t"${doytitle}"   -Xc -Yc
	#plot grdimage
	gmt grdimage ${grdfile} -JM${size} -R${range} -Ct_d.cpt -E300

	# plot san andreas fault
	gmt psxy ./historicalfaults.txt -JM${size} -R${range} -W0.5,${sanandreascolor}

	# plot BP network stations
	gmt psxy ./gmt_BPnetwork.txt -JM${size} -R${range} -St0.16 -Ggreen3 -W0.3,0-0-0

	# plot cross-section
	gmt psxy ./cross-section_BP.txt -JM${size} -R${range} -W0.5,${crosssectioncolor}

	# plot hypocenter of parkfield earthquake
	gmt psxy parkfield_hypo_strain.txt -JM${size} -R${range} -Sa0.25 -W.02,black -G${hypocolor}

	# Plot Parkfeild rupture zone
	gmt psxy parkfield_rupture_strain.txt -JM${size} -R${range} -W.25,red

	# # plot SAFOD location
	# gmt psxy ${safodfile}  -JM${size} -R${range} -Sr${safodsize} -W1.0p,${safodcolor}

	# plot coast line
	gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -L${scale} -S${oceancolor}
	gmt colorbar -JM${size} -R${range} -Baf+l@~me@~ -DJBC+h+e -Ct_d.cpt

gmt end show

