#!bin/bash

$HOME/packages/julia-1.5.3/bin/julia run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT monitoring_stats_2010-2020_stretching_OUTPUT.csv
$HOME/packages/julia-1.5.3/bin/julia run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2006-2016_stretching_OUTPUT/stack/shorttime ../OUTPUT monitoring_stats_2006-2016_stretching_OUTPUT.csv
