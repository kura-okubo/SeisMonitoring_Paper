# SeisMonitoring Paper

This repository contains the examples for SeisMonitoring.jl.

## Case study

We perform following case study to investigate the effect of each process on the dv/v time history.

| id |remove eq|normalization|filter|method| reference period |
|---|---|---|---|---|---|
|01| yes | spectral whitening + onebit | wavelet | stretching | 2010-2020 |
|02| yes | spectral whitening + onebit | wavelet | mwcs |2010-2020 |
|03| yes | no  | wavelet | mwcs | 2010-2020 |
|04| yes | no  | wavelet | stretching | 2010-2020 |
|05| yes | no  | wavelet | stretching | 2006-2016 |
|06| yes | no  | wavelet | stretching | 2007-2010 |
|07| yes | no  | wavelet | stretching | 2017-2020 |
|08| no  | no  |  wavelet | stretching | 2010-2020 |
|09| yes  | no  |  wavelet | robust stuck + stretching | 2010-2020 |
