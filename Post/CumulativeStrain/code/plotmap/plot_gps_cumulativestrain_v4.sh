#This script plots the strain rate micro strain/yr estimated from GPS

mkdir -p ../../figure/cumulativestrain_snap_dilatation
mkdir -p ../../figure/cumulativestrain_snap_shear

for comp in Eee Enn Een Efn Efp Ess
do
	mkdir -p ../../figure/cumulativestrain_snap_${comp}
done

gmt gmtset MAP_FRAME_TYPE = plain # ref:https://estuarine.jp/2017/11/gmt-5-map-frame-b/
gmt gmtset FORMAT_GEO_MAP = D # F means attaching E/W and N/S
gmt gmtset MAP_SCALE_HEIGHT = 0.3
gmt gmtset COLOR_NAN 110/110/110
gmt gmtset FONT_TITLE 13p,Helvetica,black
# plot background map
size=7
gpssize=0.06
safodsize=0.16

# zlim_dilat=-20.0/20.0/0.001
zlim_dilat=-20.0/20.0/0.001
zlim_shear=-20.0/20.0/0.001
zlim_comp_n=-20.0/20.0/0.001
zlim_comp_s=-20.0/20.0/0.001
oceancolor=white #0/140/201

hypocolor=255/73/37
stationcolor=0/25/200
oceancolor=white #0/140/201
# edgecolor=2/158/115
sanandreascolor=black
gaussiancirclecolor=black #213/94/0


header=1

maxlon=-120.2 #-119.5
minlon=-120.8 #-121.4
maxlat=36.2 #36.6
minlat=35.7 #35.4

range=${minlon}/${maxlon}/${minlat}/${maxlat}
scale=g-120.65/35.755+c36.0+w20+l"km"+f

sanandreascolor=red
safodcolor=green4
edgefile=../../data/triangular_edges.xy   	   # triangular edge file
GPSsitefile=../../data/BP_GPSstations_GMT.xy   # GPS location file
safodfile=../../data/SAFOD_location.txt

# make colorbar with limit
# gmt makecpt -D -M -T${zlim_dilat} -Cvik -I -Z -A20> t_d.cpt
# gmt makecpt -D -M -T${zlim_shear} -Cbroc -Z -A20> t_s.cpt
# make color palette from seaborn colors
python makecpt_py.py 20,250 -15 15 0.01 0 true t_d.cpt
python makecpt_py.py 210,45 -20 20 0.01 0 true t_s.cpt
python makecpt_py.py 20,250 -15 15 0.01 0 true t_cn.cpt
python makecpt_py.py 210,45 -20 20 0.01 0 true t_cs.cpt

year=2020
doy=1
# convert from day of year to date
# reference: https://stackoverflow.com/questions/42023382/convert-from-year-day-of-year-to-date-in-bash
# test conversion
# for doy in `seq 1 366`
# do
	# echo $(date -jf %s $(($(date -jf "%F" "${year}-01-01" +%s) + ((10#${doy} - 1)) * 86400)) +"%Y-%m-%d")
# done

#---plot all time snap---#
# for year in `seq 2009 2022`
# do
# for doy in `seq 0 15 365`
# do

#---plot list of date for master snapshot
years=( 2009 2014 2020 )
doys=( 15 32 61 )
for iyd in `seq 0 2`
do

year=${years[$iyd]}
doy=${doys[$iyd]}

doytitle=$(date -jf %s $(($(date -jf "%F" "${year}-01-01" +%s) + ((10#${doy} - 1)) * 86400)) +"%Y-%m-%d")

polyfile_dilatation=../../data/strain_snapshot/dilation/BP_dilatation_${year}_${doy}.dat # strain polygon file
polyfile_shear=../../data/strain_snapshot/maxshear/BP_shear_${year}_${doy}.dat # strain polygon file
polyfile_SH=../../data/strain_snapshot/SHMax/BP_SHmax_${year}_${doy}.dat # strain polygon file

if [ ! -f ${polyfile} ]; then
  echo "File ${polyfile} not found. skipping"
  continue
fi

gmt begin ../../figure/cumulativestrain_snap_dilatation/gps_cumulativestrain_dilatation_Parkfield_${year}_${doy}  eps

	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE+t"${doytitle}"   -Xc -Yc
	#plot grdimage

	# grdfile=dilation.grd                    # output grid file
	# gmt nearneighbor $xyzfile -R${range}  -I${interval} -S${radius} -G${grdfile}
	# # gmt xyz2grd $xyzfile -R$range -I$interval -G$grdfile -V
	# gmt grdimage ${grdfile} -JM${size} -R${range} -E50 -Ct_d.cpt
	# awk -F "," '(NR>'${header}'){print($1, $2)}' $velofile | gmt psxy -R${range} -JM${size} -Sc${gpssize}c -Wblack -Gwhite #plot site position
	# debug: plot station name
	# awk -F "," '(NR>'${header}'){print($1, $2, $7)}' $velofile | gmt pstext -R${range} -JM${size} -F+f8p,Helvetica,-=0.5p,blue  #plot site name

	# plot polygon
	gmt psxy ${polyfile_dilatation} -JM${size} -R${range} -G+z -Ct_d.cpt

	# plot san andreas fault
	gmt psxy ../../data/historicalfaults.txt -JM${size} -R${range} -W1.0,${sanandreascolor}

	# plot triangular edges
	gmt plot ${edgefile} -JM${size} -R${range} -W0.23,140/140/140

	# plot GPS stations and BP network
	gmt psxy ${GPSsitefile} -JM${size} -R${range} -Sr${gpssize} -G${stationcolor} #-W0,0/0/200
	gmt psxy ../../data/gmt_BPnetwork.txt -JM${size} -R${range} -St0.22 -Gwhite -W0.7,0-0-0
	# gmt psxy ../../data/circuler_coord.dat -JM${size} -R${range} -L -W0.5p,black,-

	# plot station name
	# gmt pstext ../../data/BP_GPSstations_GMT.xy -R${range} -JM${size} -F+f8p,Helvetica,-=0.5p,black+jLB  #plot site name

	# plot SAFOD location
	gmt psxy ${safodfile}  -JM${size} -R${range} -Sr${safodsize} -W1.0p,${safodcolor}

	# plot SHmax orientation
	gmt psxy ${polyfile_SH} -JM${size} -R${range} -W0.5p -Cblack

	# plot coast line
	gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -L${scale} -S${oceancolor}

	gmt colorbar -JM${size} -R${range} -Baf+l@~me@~ -DJBC+h+e -Ct_d.cpt

gmt end #show

# Max Shear

gmt begin ../../figure/cumulativestrain_snap_shear/gps_cumulativestrain_maxshear_Parkfield_${year}_${doy}  eps

	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE+t"${doytitle}"   -Xc -Yc

	# plot polygon
	gmt psxy ${polyfile_shear} -JM${size} -R${range} -G+z -Ct_s.cpt

	# plot san andreas fault
	gmt psxy ../../data/historicalfaults.txt -JM${size} -R${range} -W1.0,${sanandreascolor}

	# plot triangular edges
	gmt plot ${edgefile} -JM${size} -R${range} -W0.23,140/140/140

	# plot GPS stations and BP network
	gmt psxy ${GPSsitefile} -JM${size} -R${range} -Sr${gpssize} -G${stationcolor} #-W0,0/0/200
	gmt psxy ../../data/gmt_BPnetwork.txt -JM${size} -R${range} -St0.22 -Gwhite -W0.7,0-0-0
	# gmt psxy ../../data/circuler_coord.dat -JM${size} -R${range} -L -W0.5p,black,-

	# plot station name
	# gmt pstext ../../data/BP_GPSstations_GMT.xy -R${range} -JM${size} -F+f8p,Helvetica,-=0.5p,black+jLB  #plot site name

	# plot SAFOD location
	gmt psxy ${safodfile}  -JM${size} -R${range} -Sr${safodsize} -W1.0p,${safodcolor}

	# plot SHmax orientation
	gmt psxy ${polyfile_SH} -JM${size} -R${range} -W0.5p -Cblack

	# plot coast line
	gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -L${scale} -S${oceancolor}

	# # plot scale on the top of figure
	# gmt basemap -JM${size} -R${range} -L${scale} -Xc -Yc

	gmt colorbar -JM${size} -R${range} -Baf+l@~me@~ -DJBC+h+e -Ct_s.cpt

gmt end #show

# # Update: strain component
# for comp in Eee Enn Een Efn Efp Ess ESHmax
# do
# echo ${comp}
# polyfile_comp=../../data/strain_snapshot/${comp}/BP_${comp}_${year}_${doy}.dat # strain polygon file

# gmt begin ../../figure/cumulativestrain_snap_${comp}/gps_cumulativestrain_${comp}_Parkfield_${year}_${doy}  eps

# 	gmt basemap -JM${size} -R${range} -Ba.2f0.1 -BWSNE+t"${doytitle} ${comp}"   -Xc -Yc

# 	# plot polygon
# 	if [ "${comp}" = "Ess" ] || [ "${comp}" = "Een" ]; then
# 		gmt psxy ${polyfile_comp} -JM${size} -R${range} -G+z -Ct_cs.cpt
# 	else
# 		gmt psxy ${polyfile_comp} -JM${size} -R${range} -G+z -Ct_cn.cpt
# 	fi

# 	# plot san andreas fault
# 	gmt psxy ../../data/historicalfaults.txt -JM${size} -R${range} -W1.0,${sanandreascolor}

# 	# plot triangular edges
# 	gmt plot ${edgefile} -JM${size} -R${range} -W0.15p -Cblack -t50

# 	# plot GPS stations and BP network
# 	gmt psxy ${GPSsitefile} -JM${size} -R${range} -Sr${gpssize} -G${stationcolor} #-W0,0/0/200
# 	gmt psxy ../../data/gmt_BPnetwork.txt -JM${size} -R${range} -St0.22 -Gwhite -W0.7,0-0-0
# 	# gmt psxy ../../data/circuler_coord.dat -JM${size} -R${range} -L -W0.5p,black,-

# 	# plot station name
# 	# gmt pstext ../../data/BP_GPSstations_GMT.xy -R${range} -JM${size} -F+f8p,Helvetica,-=0.5p,black+jLB  #plot site name

# 	# plot SAFOD location
# 	gmt psxy ${safodfile}  -JM${size} -R${range} -Sr${safodsize} -W1.0p,${safodcolor}

# 	# plot SHmax orientation
# 	gmt psxy ${polyfile_SH} -JM${size} -R${range} -W0.5p -Cblack

# 	# plot fault normal and fault parallel orientation
# 	if [ "${comp}" = "Efn" ] || [ "${comp}" = "Efp" ] || [ "${comp}" = "Ess" ]; then
# 		gmt psxy fault_approx.txt -JM${size} -R${range} -W1p -Cblack
# 	fi

# 	# plot coast line
# 	gmt pscoast -JM${size} -R${range} -N2 -Dh -W1.0p,black -L${scale} -S${oceancolor}

# 	# # plot scale on the top of figure
# 	# gmt basemap -JM${size} -R${range} -L${scale} -Xc -Yc

# 	if [ "${comp}" = "Ess" ] || [ "${comp}" = "Een" ]; then
# 		echo ${comp}
# 		gmt colorbar -JM${size} -R${range} -Baf+l@~me@~ -DJBC+h+e -Ct_cs.cpt
# 	else
# 		gmt colorbar -JM${size} -R${range} -Baf+l@~me@~ -DJBC+h+e -Ct_cn.cpt
# 	fi

# gmt end #show

# done

echo ${year} ${doy} done.

done
# done
