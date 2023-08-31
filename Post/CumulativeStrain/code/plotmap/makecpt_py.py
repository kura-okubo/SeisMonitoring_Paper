#!/usr/bin/env python
# coding: utf-8
import sys
import numpy as np
# import matplotlib.pyplot as plt
# import matplotlib as mpl
import seaborn as sns

def makecpt_py(cmap_name, zmin, zmax, zstep, transparency, diverging, foname):
    """
    Make cpt file for GMT plot.
    if diverging == true, assign cmap_name as e.g "110,20" **without space**.

    2023.5.2 Kurama Okubo
    """
    zl = np.arange(zmin, zmax+0.5*zstep, zstep)
    Nzl = len(zl)

    if diverging:
        divc = np.array([float(x) for x in cmap_name.split(",")])
        lc = sns.diverging_palette(divc[0], divc[1], s=60, n=Nzl, as_cmap=False)

    else:
        lc = sns.color_palette(cmap_name, n_colors=Nzl, as_cmap=False)

    with open(foname, "wt") as fo:
        for i in range(Nzl-1):
            if i==Nzl-2:
                annot = "B"
            else:
                annot = "L"

            R0, G0, B0 = np.array([x * 255 for x in lc[i]]).astype(int)
            R1, G1, B1 = np.array([x * 255 for x in lc[i+1]]).astype(int)
            fo.write(f"{zl[i]:.6f} {R0}/{G0}/{B0}@{transparency} {zl[i+1]:.6f} {R1}/{G1}/{B1}@{transparency} {annot}\n")

        # background and foreground color
        RB, GB, BB = np.array([x * 255 for x in lc[0]]).astype(int)
        RF, GF, BF = np.array([x * 255 for x in lc[-1]]).astype(int)

        fo.write(f"B {RB}/{GB}/{BB}\n") # there would be a bug in the endpoint transparency; so remove here.
        fo.write(f"F {RF}/{GF}/{BF}\n")
        fo.write(f"N gray43")

if __name__ == "__main__":
    cmap_name, zmin, zmax, zstep, transparency, diverging, foname = sys.argv[1:]
    # print(cmap_name, zmin, zmax, zstep, transparency, diverging, foname)
    makecpt_py(cmap_name, float(zmin), float(zmax), float(zstep), float(transparency), diverging, foname)
    print(f"{foname} is created.")