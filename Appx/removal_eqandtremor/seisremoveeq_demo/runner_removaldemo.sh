#!/bin/bash

timestamp=$(date +PDT-%Y-%m-%d-%H-%M-%S)
NPROCS=4
/Applications/Julia-1.8.app/Contents/Resources/julia/bin/julia ./topo_multi_slurm_run_uwdata.jl $NPROCS 2>&1 | tee log_$timestamp.txt
