# Other test directories

### validation_of_SeisMeasurement
Test the dv/v measurement of `SeisMonitoring: seisdvv_mwcs, seisdvv_stretching` using the synthetic test data. We also evaluate the effect of clock drift and its mitigation with the MWCS.

### strain_rotation
It contains the notebooks to check the rotation of strain for the analysis of cumulative strain field around the SAF.

### get_MCMC_fixedparam
The range of MCMC parameter search has been selected by the preliminary casestudy without the bounds of parameters. This directory contains the notebooks to conduct the post-processing of the MCMC result to evaluate the median value of the maximum likelihood parameter, which is used for the MCMC sampling with fixing `a_precip` and `tmin` to improve the convergence of the samplings.
