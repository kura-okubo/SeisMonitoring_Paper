# Compute Data availability

We obtain the data availiability using the function `smstats_dataavailability` implemented in `SeisMonitoring`.

After downloading the data, we first run the `compute_DataAvailability.jl` to compile the information of data contents from the SeisIO data. The data contents is computed [when downloading the data](https://github.com/kura-okubo/SeisMonitoring.jl/blob/dev_parallel_modified/src/Utils/get_noisedatafraction.jl). The output is in csv table.

We then reproduce the figure using the `plot_DataAvailability_BP.ipynb`.
