#!/usr/bin/env python
# coding: utf-8

# # Plot CCF over 20 years
# 
# 2023.3.25 Kurama Okubo
# 
# This notebook plots the result of CCF.
# 
# 2023.4.17 update to plot 3 components tiles

# In[1]:


import datetime
import os
import time

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

# get_ipython().run_line_magic('matplotlib', 'inline')

import numpy as np
import pandas as pd

import matplotlib as mpl

plt.rcParams["font.family"] = 'Arial'
# plt.rcParams["font.sans-serif"] = "DejaVu Sans, Arial, Helvetica, Lucida Grande, Verdana, Geneva, Lucid, Avant Garde, sans-serif"
plt.rcParams["font.size"] = 12
plt.rcParams["xtick.direction"] = "in"
plt.rcParams["xtick.major.size"] = 5
plt.rcParams["xtick.major.width"] = 0.5
plt.rcParams["xtick.minor.size"] = 2
plt.rcParams["xtick.minor.width"] = 1
plt.rcParams["xtick.minor.visible"] = True


plt.rcParams["ytick.direction"] = "in"
plt.rcParams["ytick.major.size"] = 5
plt.rcParams["ytick.major.width"] = 0.5
plt.rcParams["ytick.minor.size"] = 2
plt.rcParams["ytick.minor.width"] = 1
plt.rcParams["ytick.minor.visible"] = True


# In[2]:


#---Parameters---#
fidir = "../data_npz"
freqkey = "0.9-1.2"
output_imgdir = "../figure/ccf_master"

starttime = datetime.datetime(2002, 1, 1)
endtime = datetime.datetime(2022, 6, 1)

if not os.path.exists(output_imgdir):
    os.makedirs(output_imgdir)


# In[3]:


# Read BP stations
loc_table = "./BP_gmap-stations.txt"
df_raw = pd.read_csv(loc_table, skiprows=3, header=None, sep = '|')
stationlist = np.sort(df_raw[1].values)

Nstation = len(stationlist)
# make station pairs

stationpair_list = []

for i in range(Nstation):
    jinit = i
    for j in range(jinit, Nstation):
        sta1 = stationlist[i]
        sta2 = stationlist[j]
        stationpair_list.append(f"BP.{sta1}-BP.{sta2}")


# In[5]:


complist = ["11","12","13","21","22","23","31","32","33"]


# In[6]:

def get_plotcorrdata(stationpair, comp):

    fi_stachanpair = f"{stationpair}-{comp}"
    D = np.load(fidir+f"/corrdata_{fi_stachanpair}_{freqkey}.npz")
    lags = D["lags"]
    t = D["t"]
    corr_raw = D["corr"]
    linstack_raw = D["linstack"]
    codainit = D["codainit"]
    codaend = D["codaend"]

    # compute abs_max the corr data and linear stacked data
    corr = corr_raw / np.max(corr_raw, axis=0)
    linstack = linstack_raw / np.max(linstack_raw, axis=0)
    # convert tvec to datetime
    # NOTE: The time is not always start from 0H00M, which occurs due to the lack of hourly CCF when computing daily-stacked CCF.
    uniform_tvec = [datetime.datetime.utcfromtimestamp(x) for x in t]

    return (lags, uniform_tvec, codainit, codaend, corr, linstack)


# plot parameter
vmin = -1.0
vmax = 1.0
tmax = 50
gcm = "seismic"

for stationpair in stationpair_list[0:1]:
    # stationpair = stationpair_list[0]
    sta1, sta2 = stationpair.split("-")
    sta1 = sta1.split(".")[-1]
    sta2 = sta2.split(".")[-1]

    fig, axs = plt.subplots(6, 3, figsize=(12, 14.3), sharex=False, gridspec_kw={'height_ratios': [4, 1, 4, 1, 4, 1]})
    fig.suptitle(f"{sta1}-{sta2} {freqkey}Hz");

    # Loop with 3 channel correlations    
    for comp in complist:

        comp1, comp2 = comp
        comp1 = int(comp1)
        comp2 = int(comp2)

        fi_stachanpair =  f"{stationpair}-{comp}"
        if not os.path.isfile(fidir+f"/corrdata_{fi_stachanpair}_{freqkey}.npz"):
            print(f"{fi_stachanpair} file not exists. skipping.")
            continue

        lags, uniform_tvec, codainit, codaend, corr, linstack = get_plotcorrdata(stationpair, f"{comp1}{comp2}")

        p1, p2 = [2*(comp1-1), comp2-1]
        
        # plot contour
        axs[p1, p2].pcolormesh(lags, uniform_tvec, np.transpose(corr), cmap=gcm, vmin=vmin, vmax=vmax, rasterized=True, )

        axs[p1, p2].set_xlim([-tmax, tmax])
        axs[p1, p2].set_xticks(np.linspace(-tmax, tmax, 11))
        axs[p1, p2].set_ylim([starttime, endtime])

        if f"{comp1}{comp2}" == "11":
            subplottitle = "11 (ZZ)"
        else:
            subplottitle = f"{comp1}{comp2}"

        axs[p1, p2].set_title(subplottitle)
        loc = mdates.YearLocator(2)
        axs[p1, p2].yaxis.set_major_locator(loc)
        fmt = mdates.DateFormatter('%Y')
        axs[p1, p2].yaxis.set_major_formatter(fmt)
        axs[p1, p2].set_xlabel("Time lag [s]")

        # coda window
        for i in range(2):
            axs[p1, p2].axvline(codainit[i], ls="--", c='k', lw=1.0)
            axs[p1, p2].axvline(codaend[i], ls="--", c='k', lw=1.0)

        axs[p1+1, p2].plot(lags, linstack, "k-")
        axs[p1+1, p2].set_xlim([-tmax, tmax])
        axs[p1+1, p2].set_ylim([-1.2, 1.2])
        axs[p1+1, p2].set_xticks(np.linspace(-tmax, tmax, 11))
        axs[p1+1, p2].set_xlabel("Time lag [s]")
        axs[p1+1, p2].set_ylabel("Normalized\namplitude")

        for i in range(2):
            axs[p1+1, p2].axvline(codainit[i], ls="--", c='k', lw=1.0)
            axs[p1+1, p2].axvline(codaend[i], ls="--", c='k', lw=1.0)
            

    # Adjust locations of subplots 
    fig.tight_layout(rect=[0,0,1,1.0])
    plt.subplots_adjust(hspace=0.45, wspace=0.3)

    for i in [0, 2, 4]:
        for j in range(3):
            pos1 = axs[i, j].get_position() # get the original position 
            pos2 = [pos1.x0, 0.983*pos1.y0,  pos1.width, pos1.height] 
            axs[i, j].set_position(pos2) # set a new position

    # plot shared colorbar
    fig.subplots_adjust(bottom=0.09)
    cbar_ax = fig.add_axes([0.0615, 0.04, 0.9, 0.07])
    cbar_ax.set_axis_off()
    normalize = mpl.colors.Normalize(vmin=vmin, vmax=vmax)
    cbar=fig.colorbar(mpl.cm.ScalarMappable(norm=normalize, cmap=gcm),
                     orientation='horizontal', ax=cbar_ax, location = 'bottom',
                     label="Normalized amplitude")
    cbar.set_ticks([-1.0, -0.5, 0.0, 0.5, 1.0])                   

    # save figure
    foname = (output_imgdir+"/ccf_master_allcomp_{}_{}Hz.png".format(stationpair, freqkey))
    plt.savefig(foname, dpi=150)

    plt.clf()
    plt.close()
