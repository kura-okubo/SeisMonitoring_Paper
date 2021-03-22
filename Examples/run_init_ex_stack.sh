#!/bin/sh

# test normalization
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_noramlized_2010-2020_mwcs.jl
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_noramlized_2010-2020_stretching.jl

# test reference period
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_2006-2016_stretching.jl
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_2007-2010_stretching.jl
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_2010-2020_mwcs.jl
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_2010-2020_stretching.jl
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_2017-2020_stretching.jl

# test robust stack
$HOME/packages/julia-1.5.3/bin/julia init_ex_stack_raw_robust_2010-2020_stretching.jl
