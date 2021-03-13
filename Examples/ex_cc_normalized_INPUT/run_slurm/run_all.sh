#!/bin/bash
for file in /home1/07208/kokubo09/tmpprojects/SeisMonitoring_Paper/Examples/ex_cc_normalized_INPUT/run_slurm/*.slurm; do
  echo $file
  sbatch $file
  #time sh $file
done
