#!bin/bash
np=48

# run smstats to compile csv files
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_normalized_2010-2020_mwcs_OUTPUT/stack/shorttime ../OUTPUT mwcs monitoring_stats_normalized_2010-2020_mwcs.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_normalized_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_normalized_2010-2020_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2006-2016_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_2006-2016_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2007-2010_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_2007-2010_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2010-2020_mwcs_OUTPUT/stack/shorttime ../OUTPUT mwcs monitoring_stats_raw_2010-2020_mwcs.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_2010-2020_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_2017-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_2017-2020_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_robust_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_robust_2010-2020_stretching.csv
$HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_withoutremovalEQ_2010-2020_stretching_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_withoutremovalEQ_2010-2020_stretching.csv
# $HOME/packages/julia-1.5.3/bin/julia -p $np run_smstats.jl /home1/07208/kokubo09/scratch/SeisMonitoring_Paper/ex_stack_raw_compute_codaQ_OUTPUT/stack/shorttime ../OUTPUT stretching monitoring_stats_raw_compute_codaQ.csv
