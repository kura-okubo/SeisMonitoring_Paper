#!/bin/bash

timestamp=$(date +PDT-%Y-%m-%d-%H-%M-%S)
NPROCS=16

date > log_$timestamp.txt
/home/kokubo/packages/julia-1.7.3/bin/julia /home/kokubo/project/Parkfield_BP/SeisMonitoring_Paper/Examples/ex_removeeq_raw_uwbackup_INPUT/topo_multi_slurm_run_uwdata.jl  $NPROCS 2>&1 | tee -a log_$timestamp.txt
date >> log_$timestamp.txt 
