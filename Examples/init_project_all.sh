#!/bin/sh

# juliapath=$HOME/packages/julia-1.5.3/bin/julia
juliapath=/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia
# ex download
$juliapath init_ex_download.jl

# ex removal EQ
$juliapath init_ex_removeeq_raw.jl
$juliapath init_ex_removeeq_whiten.jl

# ex cross-correlation
$juliapath init_ex_cc_raw.jl
$juliapath init_ex_cc_normalized.jl
$juliapath init_ex_cc_raw_robust.jl
$juliapath init_ex_cc_raw_withoutremovalEQ.jl

# ex stack channel collection
$juliapath init_ex_stack_channelcollection_raw.jl
$juliapath init_ex_stack_channelcollection_raw_normalized.jl
$juliapath init_ex_stack_channelcollection_raw_robust.jl
$juliapath init_ex_stack_channelcollection_raw_withoutremovalEQ.jl

# ex stack standard cases
$juliapath init_ex_stack_raw_2010-2020_stretching.jl
$juliapath init_ex_stack_raw_2010-2020_mwcs.jl

# ex stack normalization
$juliapath init_ex_stack_noramlized_2010-2020_stretching.jl
$juliapath init_ex_stack_noramlized_2010-2020_mwcs.jl

# ex stack reference period
$juliapath init_ex_stack_raw_2006-2016_stretching.jl
$juliapath init_ex_stack_raw_2007-2010_stretching.jl
$juliapath init_ex_stack_raw_2017-2020_stretching.jl

# ex robust stack
$juliapath init_ex_stack_raw_robust_2010-2020_stretching.jl

# ex without removal EQ
$juliapath init_ex_stack_raw_withoutremovalEQ_2010-2020_stretching.jl

# ex compute coda Q
$juliapath init_ex_stack_raw_compute_codaQ.jl
