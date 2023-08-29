#!/bin/sh
# compute Rayleigh wave depth sensitivity
# prepare the file; note that DT and NPTS controls the target frequency of depth sensitivity
for dt in 1.42857143 0.71428571 0.47619048 0.3125
do
echo ${dt}
rm sdisp96*
rm SRDER.PLT
rm SRDER.TXT
sprep96 -M model_Parkfield1D_CVM.dat -DT ${dt} -NPTS 2 -R -NMOD 1
sdisp96 -v
# HS and HR are dummy values
sregn96 -HS 0 -HR 0 -DER -NOQ
sdpder96 -R -TXT -K 2 -XLEN 3.0 -X0 1.0 -YLEN 4.0
mv SRDER.TXT SRDER_DT${dt}.TXT
done

plotxvig < SRDER.PLT

# for i in 
# > do
# > echo $i
# > done

# plot figure
# plotxvig < SRDER.PLT