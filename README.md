# SeisMonitoring Paper

This repository contains the examples for SeisMonitoring.jl.

## Case study

We perform following case study to investigate the effect of each process on the dv/v time history.

| id |remove eq|normalization|filter|method|
|---|---|---|---|---|
|01| yes | spectral whitening + onebit | wavelet | stretching |
|02| yes | spectral whitening + onebit | wavelet | mwcs |
|03| yes | no  | wavelet | mwcs |
|04| yes | no  | wavelet | stretching |
|05| yes | spectral whitening + onebit | Butterworth | stretching |
|06| no  | spectral whitening + onebit |  wavelet | stretching |

We further evaluate the effect of reference period on dv/v for long-term monitoring.
