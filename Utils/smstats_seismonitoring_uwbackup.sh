#!bin/bash
np=8

# run smstats to compile csv files
/home/kokubo/packages/julia-1.7.3/bin/julia -p $np run_smstats.jl /data/wsd04/Parkfield/ex_stack_raw_2010-2022_stretching_uwbackup_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_uwbackup_2010-2022_stretching.csv
