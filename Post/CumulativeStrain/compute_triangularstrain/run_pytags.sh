#!/bin/bash
#
# script runs pytags
# 
echo "running pytags: `date`"
currentdir=`pwd`

# copy the entire script from src dir
rm ./*.py
rm ./*.txt
cp ../PyTAGS/*.py .

if [ -d "./output" ]; then rm -r ./output; fi
mkdir output

# copy site file
cp ../data/BP_GPSstations.txt .
timestamp=$(date +%Y-%m-%d-%H%M%S)
python pytags.py > logpytags_$timestamp.txt 2>&1
echo "done"
echo `date`
