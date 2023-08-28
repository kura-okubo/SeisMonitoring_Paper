#!/bin/bash

# convert GeoTiff downloaded from https://viewer.nationalmap.gov/basic/#productGroupSearch to grd file
# GMT version: 6.1.1
# 2020.09.08 Kurama Okubo
# 2023.08.29 Run with GMT version: 6.2.0

for i in {35..37}
do
	for j in {119..122}
	do
		gmt grdreformat USGS_1_n${i}w${j}.tif grdn${i}w${j}.grd
		# gmt grdsample grdn${i}w${j}.grd -I1s -Ggrdn${i}w${j}_downsampled.grd
	done
done
