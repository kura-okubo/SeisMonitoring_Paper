# Plot BP sensitivity kernel with depth

1. Download and install [Computer Programs in Seismology (CPS)](https://www.eas.slu.edu/eqc/eqccps.html):
Herrmann, R. B. (2013) Computer programs in seismology: An evolving tool for instruction and research, Seism. Res. Lettr. 84, 1081-1088, doi:10.1785/0220110096.
We used the version **3.30**.

2. Download the data of velocity profile at Parkfield. We downloaded the 1D structure model from the [SCEC Unified Community Velocity Model (UCVM)](http://moho.scec.org/UCVM_web/web/viewer.php)
Note that the latlon of the Parkfield is: `35.89976042810284, -120.43258794236007` at Parkfield lodge. We selected the **CVM-H v15.1.1**. The depth profile is downloaed from `0m` to `10000m` with `50m` steps.

3. Run `Appx/BP_sensitivity_kernel/code/runit_depthsensitivity_Parkfield.sh` to compute the sensitivity kernel using the CPS.

4. Run `Appx/BP_sensitivity_kernel/plot_sensitivity_kernel_Parkfield.ipynb` to plot the sensitivity kernel. Some notes are also documented in the notebook.
