#!/bin/bash
for file in /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_raw_robust_INPUT/run_slurm/*.slurm; do
  echo $file
  sbatch $file
  #time sh $file
done
