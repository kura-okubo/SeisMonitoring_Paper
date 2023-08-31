# Note on get_MCMC_fixedparam
2023/4/18 Kurama Okubo

The MCMC inversion of model parameters has been conducted with some fixed parameters, that are `a_precip`, and `tmin` for San Simeon and Parkfield earthquakes.

To select the values of fixed parameters, we first conducted the MCMC with minimal boundaries (with iMacmini at lab: modelfit_04_MCMC_v02_usedtogetfixedparam.py).

The boundaries of model parameter are following:

| parameter | minimum  | maximum |
|---|---|---|
|a0| -1.0  | 1.0  |
|p1| -inf | inf  |
|a_precip| 0| 1.0  |
|p2| -inf | inf  |
|t_{shiftdays}|  0 | 180  |
|S1| 0.0 | 0.5 of S2 fraction |
|log10tmin1| -1 | 7.98 |
|log10tmax1| 7.5 | 12 |
|S2| 0.0 | 1.0  |
|log10tmin2| -1  | 7.98 |
|log10tmax2| 7.5 | 12 |
|b_{lin}| -inf | inf |
|logf| -10 | 10  |

 <!-- modelparam = {
              "a0"            : (0.0, [-1.0, 1.0]), # offset
              "p1"            : (0.01, [-np.inf, np.inf]), # scale of GWL
              "a_{precip}"      : (1e-2, [0, 1.0]), # delay in GWL [1/day]
              "p2"            : (0.01, [-np.inf, np.inf]), # scale of Temp
              "t_{shiftdays}"   : (7, [0, 180]), # shift of temp in days
              "S1"            : (0.03, [0.0, 0.5]), # scale in coseimic change at SS NOTE: the vmax is assigned as the factor with S1
              "log10tmin1"    : (0, [-1, 7.98]), # healing tmin duration
              "log10tmax1"    : (np.log10(1e8), [7.5, 12]), # healing tmax duration # ranging from 1 year to 30000 years
              "S2"            : (0.08, [0.0, 1.0]), # scale in coseimic change at PF
              "log10tmin2"    : (0, [-1, 7.98]), # healing tmin duration
              "log10tmax2"    : (np.log10(2.67e8), [7.5, 12]), # healing tmax duration # ranging from 1 year to 30000 years
              "b_{lin}"         : (0.0, [-np.inf, np.inf]), # slope of linear trend
              "logf"         : (0.0, [-10, 10]), # magnitude of uncertainity
              } -->

You can download the result of MCMC samplar without the parameter bounds from dasway:
[MCMC_sampler_15000_v1_nobounds.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/MCMC_sampler_15000_v1_nobounds.tar.gz) (2.2GB). Please locate this in the `processed_data`.

Then, run `appx_getfixparam_modelfit_05_MCMC_modelfit.ipynb`.
You can also download the output of this notebook from [modelparam_data_fixedparam.tar.gz](https://dasway.ess.washington.edu/shared/kokubo/parkfield_data/modelparam_data_fixedparam.tar.gz).

Then, run `appx_getfixparam_modelfit_06_MCMC_modelstatistics.ipynb` and `appx_getfixparam_modelfit_07_plot_MCMCstats.ipynb` to plot the statistical analysis of best fit model parameters.

In this calculation, we found some issues to be solved.
1. The convergence of model parameters are not good.
2. There is a trade-off between p2 and t_shiftdays due to the flip of sign on the seasonal temperature change.

To solve the problems 1, we decided to fix the parameters.
We compute the median values of `a_precip`, and `tmin` from the maximum likelihood parameter sets as the fixed parameter for the stretching mwcs method, respectively.

| fixed parameter | stretching  | mwcs |
|---|---|---|
| `a_precip` |0.0242611471128751 | 0.038884360089418896|
| `tmin San Simeon` |6.2927181557085845 | 4.902713667811209|
| `tmin Parkfield` |6.9963900156196335 | 6.992684527304036|

We rounded the values and used as fixed parameters in the next computation of MCMC.

<!--
a0, stretching:-0.03261045028455705 mwcs:-0.025633145239807448
p1, stretching:-0.0025910627460241998 mwcs:-0.0037680065346317503
a_{precip}, stretching:0.0242611471128751 mwcs:0.038884360089418896
p2, stretching:0.00072318919670095 mwcs:-3.5136217241950005e-05
t_{shiftdays}, stretching:55.2688890943079 mwcs:43.92028405001707
S1, stretching:0.00477770944128 mwcs:0.0037967753601732997
log10tmin1, stretching:6.2927181557085845 mwcs:4.902713667811209
log10tmax1, stretching:9.165732110068184 mwcs:9.74371652223777
S2, stretching:0.0314511531026462 mwcs:0.0274050668775567
log10tmin2, stretching:6.9963900156196335 mwcs:6.992684527304036
log10tmax2, stretching:8.763205859740792 mwcs:8.394682722319327
b_{lin}, stretching:1.2426130854022275e-05 mwcs:7.610336204988592e-06
logf, stretching:-4.359330696995799 mwcs:-3.5895379248241177
AIC, stretching:-8163.946458912106 mwcs:-8043.52130743457
BIC, stretching:-8109.23478857285 mwcs:-7988.8096370953135
residu_absmean, stretching:0.0199683273896687 mwcs:0.018587735665092302
residu_var, stretching:0.0008067421953554 mwcs:0.0007836186444192
tmin1, stretching:0.06223338291904612 mwcs:0.0030526724731743805
tmin2, stretching:0.3149319028505355 mwcs:0.3118385254299235
tmax1, stretching:47.38647274219723 mwcs:176.7393099797324
tmax2, stretching:18.522533204773367 mwcs:7.876127894308521
blin_1overyear, stretching:0.0045355377617181305 mwcs:0.0027777727148208357 -->

<!-- # within the range described in the modelparam.
if dvvmethod=="stretching":
    modelparam["a_{precip}_fixed"] = 0.02426
    modelparam["log10tmin1_fixed"] = 6.293
    modelparam["log10tmin2_fixed"] = 6.996

elif dvvmethod=="mwcs":
    modelparam["a_{precip}_fixed"] = 0.03888
    modelparam["log10tmin1_fixed"] = 4.903
    modelparam["log10tmin2_fixed"] = 6.993
      -->
