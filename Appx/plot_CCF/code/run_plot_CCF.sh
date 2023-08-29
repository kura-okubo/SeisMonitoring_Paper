#!/bin/sh

timestamp=$(date +PDT-%Y-%m-%d-%H-%M-%S)

/home/kokubo/packages/julia-1.7.3/bin/julia -t 6 convert_ccf_threads_uwcascadia.jl > log_$timestamp.txt 2>&1

