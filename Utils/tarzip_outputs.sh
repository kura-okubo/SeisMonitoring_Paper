#!bin/bash

root=`pwd`
for f in ../Examples/ex_*; do
	echo $f
	dirname=`dirname "$f"`
	exname1=`basename "$f"`
	echo $exname1
	exname2=${exname1/_INPUT/} 
	echo $exname2
	outputtarname=${exname2}_joboutput.tar.gz
	echo $outputtarname

	cd ${f}
	if ls out_*.txt >/dev/null 2>&1; then
		tar cvfz $outputtarname *.txt nodes*
	
	else
		echo no output file file
	fi
	cd ${root}
done