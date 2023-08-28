# Plot the map of BP network

This directory contains the script to plot the map on Parkfield and BP network.

To superimpose the topography on the map, the `grd` files are needed. Download the 1-arc-second DEM from USGS download website TNM Download (v2.0): https://apps.nationalmap.gov/downloader/#/. Then, convert the Tiff data to the .grd format using `convert_geotiff_to_grd.sh`.

The fault traces, the rupture areas and the LFE events are obtained from the references listed below.

To plot the data, run `sh plot_map_introduction_Parkfield.sh`.


**Reference:**

[1]	Shelly, D. R. A 15 year catalog of more than 1 million low-frequency earthquakes: tracking tremor and slip along the deep san andreas fault. Journal of Geophysical Research: Solid Earth, 122(5):3739-3753, 2017, doi:https://doi.org/10.1002/2017JB014047.

[2]	Johanson, I. A. and Bürgmann, R. Coseismic and postseismic slip from the 2003 san simeon earthquake and their effects on backthrust slip and the 2004 parkfield earthquake. J. Geophys. Res., 115(B7)2010, doi:https://doi.org/10.1029/2009JB006599.

[3] [1]	Mai, P. M. and Thingbaijam, K. K. S. SRCMOD: An Online Database of Finite‐Fault Rupture Models. Seismol. Res. Lett., 85(6):1348-1357, 2014, doi:https://doi.org/10.1785/0220140077.

[4]	McLaren, M. K., Hardebeck, J. L., van der Elst, N., Unruh, J. R., Bawden, G. W., and Blair, J. L. Complex Faulting Associated with the 22 December 2003 Mw 6.5 San Simeon, California, Earthquake, Aftershocks, and Postseismic Surface Deformation. Bull. Seismol. Soc. Am., 98(4):1659-1680, 2008, doi:https://doi.org/10.1785/0120070088.

[5] Fault database from U.S. Geological Survey, U.S. Geological Survey and California Geological Survey, Quaternary fault and fold database for the United States, accessed March 28, 2023, at: https://www.usgs.gov/natural-hazards/earthquake-hazards/faults

[6] Topography dataset from U.S. Geological Survey, U.S. Geological Survey3D Elevation Program 1 arc-second Resolution Digital Elevation Model, accessed August 29, 2023, at: https://data.usgs.gov/datacatalog/data/USGS:35f9c4d4-b113-4c8d-8691-47c428c29a5b.

[7] Location of BP network from http://seismo.berkeley.edu/bdsn/hrsn_overview.html
