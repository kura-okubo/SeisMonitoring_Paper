#!/bin/bash
#----------------------------------------------------
#SBATCH -p normal
#SBATCH -J ex_cc_raw_robust__2018-10-04T00-00-00__2019-09-09T00-00-00
#SBATCH -N 1
#SBATCH -n 36
#SBATCH -t 2:00:00
#SBATCH -o /scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_raw_robust_OUTPUT/out_ex_cc_raw_robust_%j__2018-10-04T00-00-00__2019-09-09T00-00-00.txt
#SBATCH -e /scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_raw_robust_OUTPUT/err_ex_cc_raw_robust_%j__2018-10-04T00-00-00__2019-09-09T00-00-00.txt
#----------------------------------------------------

date
execstart=`date +%s`
/home1/07208/kokubo09/packages/julia-1.5.3/bin/julia -p 36 /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_raw_robust_INPUT/run_slurm/juliarun__2018-10-04T00-00-00__2019-09-09T00-00-00.jl
execend=`date +%s`
runtime=$((execend-execstart))
echo $runtime > /scratch1/07208/kokubo09/SeisMonitoring_Paper/ex_cc_raw_robust_OUTPUT/exectime_ex_cc_raw_robust__2018-10-04T00-00-00__2019-09-09T00-00-00.txt
date
echo "job ex_cc_raw_robust__2018-10-04T00-00-00__2019-09-09T00-00-00 is successfully done."