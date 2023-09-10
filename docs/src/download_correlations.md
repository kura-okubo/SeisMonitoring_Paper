# Download correlation functions in Julia format

You can download the correlation functions by selecting the station pairs and components:

```@raw html
<!--- referemce: https://cs50.stackexchange.com/a/20716, https://stackoverflow.com/a/71051633 --->
<div style="padding: 10px; margin-bottom: 10px; border: 1.5px solid #808080;">
<form method="get">
<label>https://dasway.ess.washington.edu/shared/kokubo/parkfield_correlations/</label>
  <select name="correlations" id="correlations_st">
      <option value="BP.CCRB-BP.CCRB">BP.CCRB-BP.CCRB</option>
        <option value="BP.CCRB-BP.EADB">BP.CCRB-BP.EADB</option>
        <option value="BP.CCRB-BP.FROB">BP.CCRB-BP.FROB</option>
        <option value="BP.CCRB-BP.GHIB">BP.CCRB-BP.GHIB</option>
        <option value="BP.CCRB-BP.JCNB">BP.CCRB-BP.JCNB</option>
        <option value="BP.CCRB-BP.JCSB">BP.CCRB-BP.JCSB</option>
        <option value="BP.CCRB-BP.LCCB">BP.CCRB-BP.LCCB</option>
        <option value="BP.CCRB-BP.MMNB">BP.CCRB-BP.MMNB</option>
        <option value="BP.CCRB-BP.RMNB">BP.CCRB-BP.RMNB</option>
        <option value="BP.CCRB-BP.SCYB">BP.CCRB-BP.SCYB</option>
        <option value="BP.CCRB-BP.SMNB">BP.CCRB-BP.SMNB</option>
        <option value="BP.CCRB-BP.VARB">BP.CCRB-BP.VARB</option>
        <option value="BP.CCRB-BP.VCAB">BP.CCRB-BP.VCAB</option>
        <option value="BP.EADB-BP.EADB">BP.EADB-BP.EADB</option>
        <option value="BP.EADB-BP.FROB">BP.EADB-BP.FROB</option>
        <option value="BP.EADB-BP.GHIB">BP.EADB-BP.GHIB</option>
        <option value="BP.EADB-BP.JCNB">BP.EADB-BP.JCNB</option>
        <option value="BP.EADB-BP.JCSB">BP.EADB-BP.JCSB</option>
        <option value="BP.EADB-BP.LCCB">BP.EADB-BP.LCCB</option>
        <option value="BP.EADB-BP.MMNB">BP.EADB-BP.MMNB</option>
        <option value="BP.EADB-BP.RMNB">BP.EADB-BP.RMNB</option>
        <option value="BP.EADB-BP.SCYB">BP.EADB-BP.SCYB</option>
        <option value="BP.EADB-BP.SMNB">BP.EADB-BP.SMNB</option>
        <option value="BP.EADB-BP.VARB">BP.EADB-BP.VARB</option>
        <option value="BP.EADB-BP.VCAB">BP.EADB-BP.VCAB</option>
        <option value="BP.FROB-BP.FROB">BP.FROB-BP.FROB</option>
        <option value="BP.FROB-BP.GHIB">BP.FROB-BP.GHIB</option>
        <option value="BP.FROB-BP.JCNB">BP.FROB-BP.JCNB</option>
        <option value="BP.FROB-BP.JCSB">BP.FROB-BP.JCSB</option>
        <option value="BP.FROB-BP.LCCB">BP.FROB-BP.LCCB</option>
        <option value="BP.FROB-BP.MMNB">BP.FROB-BP.MMNB</option>
        <option value="BP.FROB-BP.RMNB">BP.FROB-BP.RMNB</option>
        <option value="BP.FROB-BP.SCYB">BP.FROB-BP.SCYB</option>
        <option value="BP.FROB-BP.SMNB">BP.FROB-BP.SMNB</option>
        <option value="BP.FROB-BP.VARB">BP.FROB-BP.VARB</option>
        <option value="BP.FROB-BP.VCAB">BP.FROB-BP.VCAB</option>
        <option value="BP.GHIB-BP.GHIB">BP.GHIB-BP.GHIB</option>
        <option value="BP.GHIB-BP.JCNB">BP.GHIB-BP.JCNB</option>
        <option value="BP.GHIB-BP.JCSB">BP.GHIB-BP.JCSB</option>
        <option value="BP.GHIB-BP.LCCB">BP.GHIB-BP.LCCB</option>
        <option value="BP.GHIB-BP.MMNB">BP.GHIB-BP.MMNB</option>
        <option value="BP.GHIB-BP.RMNB">BP.GHIB-BP.RMNB</option>
        <option value="BP.GHIB-BP.SCYB">BP.GHIB-BP.SCYB</option>
        <option value="BP.GHIB-BP.SMNB">BP.GHIB-BP.SMNB</option>
        <option value="BP.GHIB-BP.VARB">BP.GHIB-BP.VARB</option>
        <option value="BP.GHIB-BP.VCAB">BP.GHIB-BP.VCAB</option>
        <option value="BP.JCNB-BP.JCNB">BP.JCNB-BP.JCNB</option>
        <option value="BP.JCNB-BP.JCSB">BP.JCNB-BP.JCSB</option>
        <option value="BP.JCNB-BP.LCCB">BP.JCNB-BP.LCCB</option>
        <option value="BP.JCNB-BP.MMNB">BP.JCNB-BP.MMNB</option>
        <option value="BP.JCNB-BP.RMNB">BP.JCNB-BP.RMNB</option>
        <option value="BP.JCNB-BP.SCYB">BP.JCNB-BP.SCYB</option>
        <option value="BP.JCNB-BP.SMNB">BP.JCNB-BP.SMNB</option>
        <option value="BP.JCNB-BP.VARB">BP.JCNB-BP.VARB</option>
        <option value="BP.JCNB-BP.VCAB">BP.JCNB-BP.VCAB</option>
        <option value="BP.JCSB-BP.JCSB">BP.JCSB-BP.JCSB</option>
        <option value="BP.JCSB-BP.LCCB">BP.JCSB-BP.LCCB</option>
        <option value="BP.JCSB-BP.MMNB">BP.JCSB-BP.MMNB</option>
        <option value="BP.JCSB-BP.RMNB">BP.JCSB-BP.RMNB</option>
        <option value="BP.JCSB-BP.SCYB">BP.JCSB-BP.SCYB</option>
        <option value="BP.JCSB-BP.SMNB">BP.JCSB-BP.SMNB</option>
        <option value="BP.JCSB-BP.VARB">BP.JCSB-BP.VARB</option>
        <option value="BP.JCSB-BP.VCAB">BP.JCSB-BP.VCAB</option>
        <option value="BP.LCCB-BP.LCCB">BP.LCCB-BP.LCCB</option>
        <option value="BP.LCCB-BP.MMNB">BP.LCCB-BP.MMNB</option>
        <option value="BP.LCCB-BP.RMNB">BP.LCCB-BP.RMNB</option>
        <option value="BP.LCCB-BP.SCYB">BP.LCCB-BP.SCYB</option>
        <option value="BP.LCCB-BP.SMNB">BP.LCCB-BP.SMNB</option>
        <option value="BP.LCCB-BP.VARB">BP.LCCB-BP.VARB</option>
        <option value="BP.LCCB-BP.VCAB">BP.LCCB-BP.VCAB</option>
        <option value="BP.MMNB-BP.MMNB">BP.MMNB-BP.MMNB</option>
        <option value="BP.MMNB-BP.RMNB">BP.MMNB-BP.RMNB</option>
        <option value="BP.MMNB-BP.SCYB">BP.MMNB-BP.SCYB</option>
        <option value="BP.MMNB-BP.SMNB">BP.MMNB-BP.SMNB</option>
        <option value="BP.MMNB-BP.VARB">BP.MMNB-BP.VARB</option>
        <option value="BP.MMNB-BP.VCAB">BP.MMNB-BP.VCAB</option>
        <option value="BP.RMNB-BP.RMNB">BP.RMNB-BP.RMNB</option>
        <option value="BP.RMNB-BP.SCYB">BP.RMNB-BP.SCYB</option>
        <option value="BP.RMNB-BP.SMNB">BP.RMNB-BP.SMNB</option>
        <option value="BP.RMNB-BP.VARB">BP.RMNB-BP.VARB</option>
        <option value="BP.RMNB-BP.VCAB">BP.RMNB-BP.VCAB</option>
        <option value="BP.SCYB-BP.SCYB">BP.SCYB-BP.SCYB</option>
        <option value="BP.SCYB-BP.SMNB">BP.SCYB-BP.SMNB</option>
        <option value="BP.SCYB-BP.VARB">BP.SCYB-BP.VARB</option>
        <option value="BP.SCYB-BP.VCAB">BP.SCYB-BP.VCAB</option>
        <option value="BP.SMNB-BP.SMNB">BP.SMNB-BP.SMNB</option>
        <option value="BP.SMNB-BP.VARB">BP.SMNB-BP.VARB</option>
        <option value="BP.SMNB-BP.VCAB">BP.SMNB-BP.VCAB</option>
        <option value="BP.VARB-BP.VARB">BP.VARB-BP.VARB</option>
        <option value="BP.VARB-BP.VCAB">BP.VARB-BP.VCAB</option>
        <option value="BP.VCAB-BP.VCAB">BP.VCAB-BP.VCAB</option>
  </select>
  <label>-</label>
  <select name="correlations" id="correlations_chan">
        <option value="11">11</option>
        <option value="12">12</option>
        <option value="13">13</option>
        <option value="21">21</option>
        <option value="22">22</option>
        <option value="23">23</option>
        <option value="31">31</option>
        <option value="32">32</option>
        <option value="33">33</option>
  </select>
  <label>.jld2</label>
</form>
<br>
<button type="button" id="submit" style="font-size: 16px;">Download</button>

</div>

<script>
document.getElementById('submit').onclick = function(){
  window.location.href = "https://dasway.ess.washington.edu/shared/kokubo/parkfield_correlations/"+document.getElementById('correlations_st').value+"-"+document.getElementById('correlations_chan').value+".jld2";
};
</script>

```


## Read the correlation functions
You can read the correlation functions stored in the `.jld2` file as follows:

```julia
julia> using SeisIO, SeisNoise, JLD2

julia> t = jldopen("SeisMonitoring_Paper/Appx/plot_CCF/data/BP.EADB-BP.LCCB-11.jld2", "r")
JLDFile SeisMonitoring_Paper/Appx/plot_CCF/data/BP.EADB-BP.LCCB-11.jld2 (read-only)
 ├─📂 2002-01-01T00:00:00--2002-01-02T00:00:00
 │  ├─🔢 0.2-0.5
 │  ├─🔢 0.5-0.9
 │  ├─🔢 0.9-1.2
 │  └─🔢 1.2-2.0
 ├─📂 2002-01-02T00:00:00--2002-01-03T00:00:00
 │  ├─🔢 0.2-0.5
 │  ├─🔢 0.5-0.9
 │  └─ ⋯ (2 more entries)
 └─ ⋯ (7256 more entries)

julia> C = t["2002-09-01T00:00:00--2002-09-02T00:00:00/0.9-1.2"]
CorrData with 1 Corrs
      NAME: "BP.EADB..BP1.BP.LCCB..BP1"
        ID: "2002-09-01"
       LOC: 35.8952 N, -120.423 E, 224.0 m
      COMP: "11"
   ROTATED: false
 CORR_TYPE: "CC"
        FS: 20.0
      GAIN: 1.0
   FREQMIN: 0.9
   FREQMAX: 1.2
    CC_LEN: 3600.0
   CC_STEP: 1800.0
  WHITENED: false
 TIME_NORM: ""
      RESP: a0 1.0, f0 1.0, 1z, 1p
      MISC: 10 entries
     NOTES: 13 entries
      DIST: 12.528
       AZI: 318.74
       BAZ: 138.686
    MAXLAG: 100.0
         T: 2002-09-01T00:30:00                …
      CORR: 4001×1 Matrix{Float32}

julia>
```

Here `C` is the type of `SeisNoise.CorrData` containing the correlation function in `C.corr` and the meta data. See the documentation of [SeisNoise.jl](https://github.com/tclements/SeisNoise.jl/tree/master) for the usage of the `CorrData`.

# Download correlation functions in `.npz` format

To plot the correlation function in `Appx/plot_CCF`, we generated the correlation functions associated with the frequency range of 0.9-1.2Hz in [`.npz`](https://numpy.org/doc/stable/reference/routines.io.html#numpy-binary-files-npy-npz) format. You can download and locate it in `Appx/plot_CCF/data_npz/` and run `Appx/plot_CCF/code/plot_ccf_master_v04_medianmute.ipynb` to plot the CFs.

```@raw html
<div style="padding: 10px; margin-bottom: 10px; border: 1.5px solid #808080;">
<form method="get">
<label>https://dasway.ess.washington.edu/shared/kokubo/parkfield_ccf_data_npz/corrdata_</label>
  <select name="correlations" id="correlations_npz">
      <option value="BP.CCRB-BP.CCRB">BP.CCRB-BP.CCRB</option>
        <option value="BP.CCRB-BP.EADB">BP.CCRB-BP.EADB</option>
        <option value="BP.CCRB-BP.FROB">BP.CCRB-BP.FROB</option>
        <option value="BP.CCRB-BP.GHIB">BP.CCRB-BP.GHIB</option>
        <option value="BP.CCRB-BP.JCNB">BP.CCRB-BP.JCNB</option>
        <option value="BP.CCRB-BP.JCSB">BP.CCRB-BP.JCSB</option>
        <option value="BP.CCRB-BP.LCCB">BP.CCRB-BP.LCCB</option>
        <option value="BP.CCRB-BP.MMNB">BP.CCRB-BP.MMNB</option>
        <option value="BP.CCRB-BP.RMNB">BP.CCRB-BP.RMNB</option>
        <option value="BP.CCRB-BP.SCYB">BP.CCRB-BP.SCYB</option>
        <option value="BP.CCRB-BP.SMNB">BP.CCRB-BP.SMNB</option>
        <option value="BP.CCRB-BP.VARB">BP.CCRB-BP.VARB</option>
        <option value="BP.CCRB-BP.VCAB">BP.CCRB-BP.VCAB</option>
        <option value="BP.EADB-BP.EADB">BP.EADB-BP.EADB</option>
        <option value="BP.EADB-BP.FROB">BP.EADB-BP.FROB</option>
        <option value="BP.EADB-BP.GHIB">BP.EADB-BP.GHIB</option>
        <option value="BP.EADB-BP.JCNB">BP.EADB-BP.JCNB</option>
        <option value="BP.EADB-BP.JCSB">BP.EADB-BP.JCSB</option>
        <option value="BP.EADB-BP.LCCB">BP.EADB-BP.LCCB</option>
        <option value="BP.EADB-BP.MMNB">BP.EADB-BP.MMNB</option>
        <option value="BP.EADB-BP.RMNB">BP.EADB-BP.RMNB</option>
        <option value="BP.EADB-BP.SCYB">BP.EADB-BP.SCYB</option>
        <option value="BP.EADB-BP.SMNB">BP.EADB-BP.SMNB</option>
        <option value="BP.EADB-BP.VARB">BP.EADB-BP.VARB</option>
        <option value="BP.EADB-BP.VCAB">BP.EADB-BP.VCAB</option>
        <option value="BP.FROB-BP.FROB">BP.FROB-BP.FROB</option>
        <option value="BP.FROB-BP.GHIB">BP.FROB-BP.GHIB</option>
        <option value="BP.FROB-BP.JCNB">BP.FROB-BP.JCNB</option>
        <option value="BP.FROB-BP.JCSB">BP.FROB-BP.JCSB</option>
        <option value="BP.FROB-BP.LCCB">BP.FROB-BP.LCCB</option>
        <option value="BP.FROB-BP.MMNB">BP.FROB-BP.MMNB</option>
        <option value="BP.FROB-BP.RMNB">BP.FROB-BP.RMNB</option>
        <option value="BP.FROB-BP.SCYB">BP.FROB-BP.SCYB</option>
        <option value="BP.FROB-BP.SMNB">BP.FROB-BP.SMNB</option>
        <option value="BP.FROB-BP.VARB">BP.FROB-BP.VARB</option>
        <option value="BP.FROB-BP.VCAB">BP.FROB-BP.VCAB</option>
        <option value="BP.GHIB-BP.GHIB">BP.GHIB-BP.GHIB</option>
        <option value="BP.GHIB-BP.JCNB">BP.GHIB-BP.JCNB</option>
        <option value="BP.GHIB-BP.JCSB">BP.GHIB-BP.JCSB</option>
        <option value="BP.GHIB-BP.LCCB">BP.GHIB-BP.LCCB</option>
        <option value="BP.GHIB-BP.MMNB">BP.GHIB-BP.MMNB</option>
        <option value="BP.GHIB-BP.RMNB">BP.GHIB-BP.RMNB</option>
        <option value="BP.GHIB-BP.SCYB">BP.GHIB-BP.SCYB</option>
        <option value="BP.GHIB-BP.SMNB">BP.GHIB-BP.SMNB</option>
        <option value="BP.GHIB-BP.VARB">BP.GHIB-BP.VARB</option>
        <option value="BP.GHIB-BP.VCAB">BP.GHIB-BP.VCAB</option>
        <option value="BP.JCNB-BP.JCNB">BP.JCNB-BP.JCNB</option>
        <option value="BP.JCNB-BP.JCSB">BP.JCNB-BP.JCSB</option>
        <option value="BP.JCNB-BP.LCCB">BP.JCNB-BP.LCCB</option>
        <option value="BP.JCNB-BP.MMNB">BP.JCNB-BP.MMNB</option>
        <option value="BP.JCNB-BP.RMNB">BP.JCNB-BP.RMNB</option>
        <option value="BP.JCNB-BP.SCYB">BP.JCNB-BP.SCYB</option>
        <option value="BP.JCNB-BP.SMNB">BP.JCNB-BP.SMNB</option>
        <option value="BP.JCNB-BP.VARB">BP.JCNB-BP.VARB</option>
        <option value="BP.JCNB-BP.VCAB">BP.JCNB-BP.VCAB</option>
        <option value="BP.JCSB-BP.JCSB">BP.JCSB-BP.JCSB</option>
        <option value="BP.JCSB-BP.LCCB">BP.JCSB-BP.LCCB</option>
        <option value="BP.JCSB-BP.MMNB">BP.JCSB-BP.MMNB</option>
        <option value="BP.JCSB-BP.RMNB">BP.JCSB-BP.RMNB</option>
        <option value="BP.JCSB-BP.SCYB">BP.JCSB-BP.SCYB</option>
        <option value="BP.JCSB-BP.SMNB">BP.JCSB-BP.SMNB</option>
        <option value="BP.JCSB-BP.VARB">BP.JCSB-BP.VARB</option>
        <option value="BP.JCSB-BP.VCAB">BP.JCSB-BP.VCAB</option>
        <option value="BP.LCCB-BP.LCCB">BP.LCCB-BP.LCCB</option>
        <option value="BP.LCCB-BP.MMNB">BP.LCCB-BP.MMNB</option>
        <option value="BP.LCCB-BP.RMNB">BP.LCCB-BP.RMNB</option>
        <option value="BP.LCCB-BP.SCYB">BP.LCCB-BP.SCYB</option>
        <option value="BP.LCCB-BP.SMNB">BP.LCCB-BP.SMNB</option>
        <option value="BP.LCCB-BP.VARB">BP.LCCB-BP.VARB</option>
        <option value="BP.LCCB-BP.VCAB">BP.LCCB-BP.VCAB</option>
        <option value="BP.MMNB-BP.MMNB">BP.MMNB-BP.MMNB</option>
        <option value="BP.MMNB-BP.RMNB">BP.MMNB-BP.RMNB</option>
        <option value="BP.MMNB-BP.SCYB">BP.MMNB-BP.SCYB</option>
        <option value="BP.MMNB-BP.SMNB">BP.MMNB-BP.SMNB</option>
        <option value="BP.MMNB-BP.VARB">BP.MMNB-BP.VARB</option>
        <option value="BP.MMNB-BP.VCAB">BP.MMNB-BP.VCAB</option>
        <option value="BP.RMNB-BP.RMNB">BP.RMNB-BP.RMNB</option>
        <option value="BP.RMNB-BP.SCYB">BP.RMNB-BP.SCYB</option>
        <option value="BP.RMNB-BP.SMNB">BP.RMNB-BP.SMNB</option>
        <option value="BP.RMNB-BP.VARB">BP.RMNB-BP.VARB</option>
        <option value="BP.RMNB-BP.VCAB">BP.RMNB-BP.VCAB</option>
        <option value="BP.SCYB-BP.SCYB">BP.SCYB-BP.SCYB</option>
        <option value="BP.SCYB-BP.SMNB">BP.SCYB-BP.SMNB</option>
        <option value="BP.SCYB-BP.VARB">BP.SCYB-BP.VARB</option>
        <option value="BP.SCYB-BP.VCAB">BP.SCYB-BP.VCAB</option>
        <option value="BP.SMNB-BP.SMNB">BP.SMNB-BP.SMNB</option>
        <option value="BP.SMNB-BP.VARB">BP.SMNB-BP.VARB</option>
        <option value="BP.SMNB-BP.VCAB">BP.SMNB-BP.VCAB</option>
        <option value="BP.VARB-BP.VARB">BP.VARB-BP.VARB</option>
        <option value="BP.VARB-BP.VCAB">BP.VARB-BP.VCAB</option>
        <option value="BP.VCAB-BP.VCAB">BP.VCAB-BP.VCAB</option>
  </select>
  <label>-</label>
  <select name="correlations" id="correlations_channpz">
        <option value="11">11</option>
        <option value="12">12</option>
        <option value="13">13</option>
        <option value="21">21</option>
        <option value="22">22</option>
        <option value="23">23</option>
        <option value="31">31</option>
        <option value="32">32</option>
        <option value="33">33</option>
  </select>
  <label>_0.9-1.2.npz</label>
</form>
<br>
<button type="button" id="submit_npz" style="font-size: 16px;">Download</button>

</div>

<script>
document.getElementById('submit_npz').onclick = function(){
  window.location.href = "https://dasway.ess.washington.edu/shared/kokubo/parkfield_ccf_data_npz/corrdata_"+document.getElementById('correlations_npz').value+"-"+document.getElementById('correlations_channpz').value+"_0.9-1.2.npz";
};
</script>

```

### Contents of `.npz` corrfile

| key | value |
| :--- | :--- |
|`coda_init_factor` | coda window starts from the ballistic wave arrival time x `coda_init_factor` |
|`max_coda_length`| the end of coda window, which is fixed in this study |
|`lags` | lag time vector |
|`linstack` | linear stack reference of corrs over the entire study period|
|`t` | time windows used for the linear stack|
|`corr`| cross-correlation function|
|`vel`| velocity used to estimate ballistic wave arrival time in [km/s]|
|`codainit` | start time of coda window, symmetric with positive and negative lags|
| `codaend` | end time of coda window, symmetric with positive and negative lags|

You can extract data as followings:

```python
import numpy as np
D = np.load(f"corrdata_{fi_stachanpair}_0.9-1.2.npz")
lags = D["lags"]
t = D["t"]
corr_raw = D["corr"]
linstack_raw = D["linstack"]
codainit = D["codainit"]
codaend = D["codaend"]
```
