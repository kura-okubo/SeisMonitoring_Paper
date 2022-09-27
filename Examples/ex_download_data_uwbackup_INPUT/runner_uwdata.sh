#!/bin/bash

timestamp=$(date +PDT-%Y-%m-%d-%H-%M-%S)
NPROCS=4
/home/kokubo/packages/julia-1.7.2/bin/julia /home/kokubo/project/SeisMonitoring_Paper/Examples/ex_download_data_uwbackup_INPUT/topo_multi_slurm_run_uwdata.jl $NPROCS 2>&1 | tee log_$timestamp.txt
