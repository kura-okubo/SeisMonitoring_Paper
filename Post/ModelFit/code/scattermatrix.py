# module to plot the scatter matrix
# 2023.1.8 Kurama Okubo

import os
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
from scipy.stats import norm
import pickle

def plot_scattermatrix(A, datainds, labels, left=0.1, right=0.9, bottom=0.1, top=0.9, wspace=0.05, hspace=0.05,
    xrange_sigma_factor=3, bincolorgray=0.7, nbin_hist=20, nbin_hist2d=20, Ncontourf=101, Ncontour=7, Ncontour_clip=6, cmap="viridis",
    xticks=None, yticks=None, plot_truth=True, rastarized=True,
    ylim_max=None, zlim_max=None, xranges=None, plot_median=False, plot_bestparam=False, labelfontsize=20, tickfontsize=14, figsize=(12, 12)):

    """
    plot scatter matrix.
    Input:
        A: Array(Ndata, Nparameter)
            The array of data set with respect to the parameters.

        datainds: List
            The index list to define which rows we plot. e.g. [0, 1, 5, 3]

        labels: List
            The label of parameters. The size should be identical to the size of datainds.

        left, right, bottom, top, wspace, hspace: Float
            The parameters associated with matplotlib.pyplot.subplots_adjust

        xrange_sigma_factor: Float
            The factor to determine the xlim.

        bincolorgray: Float
            The gray density of bins of the histogram on diagonals.

        nbin_hist: Int
            The number of bins on the histogram.

        nbin_hist2d: Int
            The number of bins on the 2d histogram.

        Ncontourf, Ncontour, Ncontour_clip: Int
            The number of levels on contourf and contour, respectively. The contour lines are plotted
            from the first 'Ncontour_clip' lines, and clip the lower contours.

        plot_median: Bool
            Plot the median and percentiles on the histogram

        plot_truth: Bool, plot_bestparam: List
            Plot the values of best parameters on the histogram.

        ylim_max: Int
            The ylim max as ylim(0, ylim_max). If not given, it is automatically assigned.
            
        xticks, yticks, xranges: Array
            Specify the ticks and ranges of the axis.

        figsize, labelfontsize, tickfontsize: Int
            The size of figure and fonts.
    """

    assert len(datainds) == len(labels)
    Ndim = len(datainds)
    Ndata = A.shape[0]

    if ylim_max is None:
        ylim_max = 0.6 #np.rint(0.4*Ndata)
    
    if zlim_max is None:
        zlim_max = 0.6 #np.rint(0.4*Ndata)

    # Trim the data array
    A1 = np.zeros((Ndata, Ndim))

    for i, ind in enumerate(datainds):
        A1[:, i] = A[:, ind]

    # create subplots
    fig, axs = plt.subplots(Ndim, Ndim, figsize=figsize)

    # remove upper right axes
    for j in range(1, Ndim):
        for i in range(0, j):
            fig.delaxes(axs[i, j])
        
    fig.subplots_adjust(left=left, bottom=bottom, right=right, top=top, wspace=wspace, hspace=hspace)

    # 1. Plot histogram on the diagonal matrix
    xrangeflag=False
    if xranges is None:
        xranges = np.zeros((Ndim, 2))
    else:
        xrangeflag=True

    for i in range(Ndim):
        ax = axs[i, i]
        
        if i<Ndim-1:
            ax.set(xticklabels=[])
        
        if i>0:
            ax.set(yticklabels=[])
        
        ax.minorticks_off()

        #---automatically determine the xrange of distribution---#
        # To represent the kurtosis of distribution, we first fit the gaussian and evaluate the mean and std.
        # We also evaluate the minimum and maximum value in the case with uniformly random distribution.
        # Then, we make a range from -xrange_sigma_factor to xrange_sigma_factor sigma from the mean, or min and max of data.
        #---------------------------------------------------------#
        
        data = A1[:, i]
        m1, s1 = norm.fit(data)
        if not xrangeflag:
            xranges[i, 0] = max(data.min(), m1-xrange_sigma_factor*s1) # xmin
            xranges[i, 1] = min(data.max(), m1+xrange_sigma_factor*s1) # xmax
                    
        # noramlize bins as the sum of it is unity (probability mass)
        # ref: https://stackoverflow.com/questions/3866520/plot-a-histogram-such-that-bar-heights-sum-to-1-probability
        weights = np.ones_like(data) / len(data)
        ncount, bins, patches = ax.hist(data, bins=nbin_hist, range=xranges[i], color=[bincolorgray, bincolorgray, bincolorgray],
                edgecolor='black',  weights=weights, linewidth=0.4, density=False)
        ax.set_xlim(xranges[i])
        ax.set_yticks(np.arange(0, 1.0, 0.1))
        ax.set_ylim(0, ylim_max)

        if xticks:
            ax.set_xticks(xticks[i])

        if i==0:
            ax.set_ylabel("probability", fontsize=labelfontsize)

        if i==Ndim-1:
            ax.set_xlabel(labels[i], fontsize=labelfontsize)
            plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")

        # plot median and percentiles
        if plot_median:
            # mean
            datamean = np.mean(data)
            # percentile and median
            (perc1, median, perc2) = np.percentile(data, [16, 50, 84])
            # mode 
            datamode = bins[ncount.argmax()]

            # ax.axvline(datamean, c="y", lw=1, ls="-")
            # ax.axvline(datamode, c="c", lw=1, ls="-")
            ax.axvline(median, c="r", lw=1, ls="-")
            ax.axvline(perc1, c="g", lw=1, ls="--")
            ax.axvline(perc2, c="b", lw=1, ls="--")

        if  isinstance(plot_bestparam, np.ndarray) or isinstance(plot_bestparam, list):
            ax.axvline(plot_bestparam[i], c="k", lw=1.0, ls="-")

        plt.setp(ax.get_xticklabels(), fontsize=tickfontsize)
        plt.setp(ax.get_yticklabels(), fontsize=tickfontsize)

    #2. Plot 2d histogram
        
    for i in range(1, Ndim):
        for j in range(0, i):
            ax = axs[i, j]
            data_y =  A1[:, i]
            data_x =  A1[:, j]
            
            #---------------------------------------------------------------------------------------------------#
            #Here we refer: https://github.com/dfm/corner.py/blob/fccea83ba58c94e7a78c65c51c05d9586388d99b/src/corner/core.py#L518
            Z, X, Y = np.histogram2d(data_x, data_y, bins=nbin_hist2d, range=[xranges[j], xranges[i]],
                                     weights=np.ones_like(data_x) / len(data_x))
            
            # Compute the bin centers.
            mX = (X[:-1] + X[1:])/2
            mY = (Y[:-1] + Y[1:])/2
            dx = X[1] - X[0]
            dy = Y[1] - Y[0]
            
            mX2 = np.concatenate([[mX[0] - 2*dx, mX[0] - dx], mX, [mX[-1]+dx, mX[-1]+2*dx]])
            mY2 = np.concatenate([[mY[0] - 2*dy, mY[0] - dy], mY, [mY[-1]+dy, mY[-1]+2*dy]])
            Z2 = Z.min() + np.zeros(Z.shape+np.array([4,4]))
            Z2[2:-2, 2:-2] = Z
            for l, m in zip([1,-2], [0, -1]):
                Z2[2:-2, l] = Z[:, m]
                Z2[l, 2:-2] = Z[m, :]
                Z2[1, l] = Z[0, m]
                Z2[-2, l] = Z[m, 0]
            #---------------------------------------------------------------------------------------------#
            
            # We then normalize the Z2
            # norm_Z = mpl.colors.Normalize(vmin=0, vmax=Z2.max())
            norm_Z = mpl.colors.Normalize(vmin=0, vmax=zlim_max)
            
            # compute levels using MaxNLocator
            mnloc = mpl.ticker.MaxNLocator(nbins=Ncontour)
            levels = mnloc.tick_values(0, Z2.max()) 
            levels_clipped = levels[Ncontour-Ncontour_clip:]# remove the lower levels

            h1 = ax.contourf(mX2, mY2, Z2.T, Ncontourf, norm=norm_Z, zorder=-10, cmap=cmap)

            if rastarized==True:
                # Rasterize the contour
                for c in h1.collections:
                    c.set_rasterized(True)
            
            # plot contour line
            ax.contour(mX2, mY2, Z2.T, levels_clipped, norm=norm_Z, colors='k', zorder=-9, linewidths=0.8)

            # plot truth marker
            if plot_truth:
                ax.plot(plot_bestparam[j], plot_bestparam[i], "bo", ms=5, markeredgecolor="w", lw=1.0);

            ax.set_xlim(xranges[j])
            ax.set_ylim(xranges[i])
            if xticks:
                ax.set_xticks(xticks[j])
            if yticks:
                ax.set_yticks(yticks[i-1])

            ax.ticklabel_format(axis='both', style='sci', scilimits=(-5, 5), useOffset=True, useLocale=True, useMathText=True)

            if j==0:
                ax.set_ylabel(labels[i], fontsize=labelfontsize)
                # ax.yaxis.set_tick_params(rotation=45)

            else:
                ax.set(yticklabels=[])

            if i==Ndim-1:
                ax.set_xlabel(labels[j], fontsize=labelfontsize)
                plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")

                # ax.xaxis.set_major_locator(mpl.ticker.FixedLocator(ax.get_xticks().tolist()))
                # ax.set_xticklabels(ax.get_xticklabels(), rotation = -45)

            else:
                ax.set(xticklabels=[])
                                
            plt.setp(ax.get_xticklabels(), fontsize=tickfontsize)
            plt.setp(ax.get_yticklabels(), fontsize=tickfontsize)

    # compute the scalar mappable to plot colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm_Z)

    return fig, axs, sm