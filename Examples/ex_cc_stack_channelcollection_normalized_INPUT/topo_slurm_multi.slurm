#!/bin/bash
#----------------------------------------------------
#SBATCH -p normal
#SBATCH -J BP_SeisMonitoring
#SBATCH -N 10
#SBATCH --ntasks-per-node 48
#SBATCH -t 2:00:00
#SBATCH -o /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_stack_channelcollection_normalized_INPUT/out_%j.txt
#SBATCH -e /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_stack_channelcollection_normalized_INPUT/err_%j.txt
#----------------------------------------------------

date

MACHINEFILE="nodes.$SLURM_JOBID"
# Generate Machinefile for mpich such that hosts are in the same
#  order as if run via srun
srun -l /bin/hostname | sort -n | awk '{print $2}' > $MACHINEFILE

/home1/07208/kokubo09/packages/julia-1.5.3/bin/julia /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_stack_channelcollection_normalized_INPUT/topo_multi_slurm_run.jl 480 $MACHINEFILE

date
echo "job BP_SeisMonitoring is successfully done."
