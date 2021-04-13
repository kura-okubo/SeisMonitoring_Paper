#!bin/bash
np=48

#$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_2010-2020_stretching_OUTPUT.csv
#$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2010-2020_mwcs_OUTPUT/stack/shorttime ../OUTPUT mwcs monitoring_stats_2010-2020_mwcs_OUTPUT.csv
#$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_normalized_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_normalized_2010-2020_stretching_OUTPUT.csv

$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_normalized_2010-2020_mwcs_OUTPUT/stack/shorttime ../OUTPUT mwcs monitoring_stats_normalized_2010-2020_mwcs_OUTPUT.csv

$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_robust_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_robust_2010-2020_stretching_OUTPUT.csv

#$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2006-2016_stretching_OUTPUT/stack/shorttime ../OUTPUT monitoring_stats_2006-2016_stretching_OUTPUT.csv
