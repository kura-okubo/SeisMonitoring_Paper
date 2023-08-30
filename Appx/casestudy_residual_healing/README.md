# Workflow of the MCMC parameter search with the residual healing model

1. Run `modelfit_04_MCMC_v05_2_reshealtest.py` to conduct the MCMC parameter search. Note that the `MCMC_func_resheal.py` includes the residual healing model. The data of dv/v are imported from the `Post/ModelFit`, so please first run the scripts there. You can download the result of MCMC sampling from [MCMC_sampler_20000_v2_resheal.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_20000_v2_resheal.tar.gz) (145MB)

2. Run `resheal_plot_MCMCscattermatrix_stretching/mwcs.ipynb` to post-process the MCMC result.

3. Run `code/resheal_plot_MCMCdvvmodelfit.ipynb` to plot the comparison of the model with residual healing term and the data of dv/v.
