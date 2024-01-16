#!/bin/bash
maxlon=-120.2 #-119.5
minlon=-120.8 #-121.4
maxlat=36.2 #36.6
minlat=35.7 #35.4

range=${minlon}/${maxlon}/${minlat}/${maxlat}

interval=0.5km

filename=./BP_StrainChange_dilation.xyz

echo "convert $filename"
gmt xyz2grd ${filename} -R${range} -I${interval} -G${filename}.grd
