#!/bin/sh

# test normalization
julia init_ex_stack_noramlized_2010-2020_mwcs.jl
julia init_ex_stack_noramlized_2010-2020_stretching.jl

# test reference period
julia init_ex_stack_raw_2006-2016_stretching.jl
julia init_ex_stack_raw_2007-2010_stretching.jl
julia init_ex_stack_raw_2010-2020_mwcs.jl
julia init_ex_stack_raw_2010-2020_stretching.jl
julia init_ex_stack_raw_2017-2020_stretching.jl

# test robust stack
julia init_ex_stack_raw_robust_2010-2020_stretching.jl
