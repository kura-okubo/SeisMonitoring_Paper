# Compute the coseismic dilatational strain change

We computed the change in the dilatational strain caused by the coseismic slip of the 2004 Parkfield earthquake using [coulomb3.3](https://www.usgs.gov/publications/coulomb-33-graphic-rich-deformation-and-stress-change-software-earthquake-tectonic-and).

## Process flow

1. Run `compute_strain_BP/code/01_BP_compute_geometry_coseismicstrain.ipynb` to compute the geometry of cross-section across the fault.
2. We used the command of coulomb33 `srcmod2coulomb` and selected `s2004PARKFLjich` to save the coulomb33 input file. You can skip this step as we already saved the `coulomb33_inputfiles/s2004PARKFIjich_200f_coulomb.inp` with the refined grid and a given depth.
> The new version of coulomb33 loads the `SRCMOD_2021.mat` by default. Change it to `SRCMOD_JUL07_v7.mat` to load the file above.
3. Launch Coulomb3.3 and import `coulomb33_inputfiles/s2004PARKFIjich_200f_coulomb.inp`.
4. Compute the dilation, cross-section and rename the output with `_BP`. Use `coulomb33_inputfiles/Cross_section.dat` to set the location of cross-section.
5. Run `compute_strain_BP/code/02_plot_dilation_cross-section_BP.ipynb` to plot the cross-section. To plot the fault on the cross-section figure, run `compute_strain_BP/code/BP_computeFaultgeom.m` and get the coordinates of the fault.
6. Run `plot_strain_gmt/convert_strain_to_gmt_BP.m`, `plot_strain_gmt/convert_strainxyz2grd.sh` and `plot_strain_gmt/plot_BP_dilation.sh` to plot the horizontal strain field.

## Tips

- The `resources` is reserved name in Matlab (see [this](https://jp.mathworks.com/matlabcentral/answers/721299-coulomb-3-3-build-input-from-cmt-or-focal-mech-data#answer_605758)), so rename it and add path to the directory to run Coulomb3.3.

-  We use the SRCMOD data of preset file (`SRCMOD_JUL07_v7.mat`) because the mat file download from http://equake-rc.info/SRCMOD/searchmodels/viewmodel/s2004PARKFI01JIxx/ causes an issue associated with invNoTW. s2004PARKFI01JIxx.mat set `invNoTW = 999`, which causes the incorrect loop of slip calculation. To avoid that, we used the one from `SRCMOD_JUL07_v7.mat`. You may also solve this issue by modifying it to `invNoTW = 1` in the raw mat file. Note that the slip profile is identical between those files. 

