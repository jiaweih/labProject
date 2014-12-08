#/usr/bin/python

from mpl_toolkits.basemap import Basemap, cm
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib as mpl
from functions_common import plot_basemap,cbar_extend,get_data,plot_colorbar,cbar_unit




def get_vmin_vmax_seasonal(parent_dir,var,var_names,scenario,seasons):             
    var_name = var_names[var]
    cbar_min = []
    cbar_max = []
    for idx,season in enumerate(seasons):
        source_dir = parent_dir.format(scenario,var,season)
        nc = Dataset(source_dir,'r')
        data = nc.variables[var_name][0][:]
        cbar_min.append(np.min(data))
        cbar_max.append(np.max(data))
        nc.close()
    vmin = np.min(cbar_min)
    vmax = np.max(cbar_max)
    return (vmin,vmax)


def plot_figure_seasonal(parent_dir,store_dir,scenarios,variables,var_names,seasons,fig_size,nrow,ncol,height_ratio,width_ratio,\
                wspace,hspace,border,vmin,vmax,cbar_cax,cbar_tick_size,cbar_label_size,text_size,cmap,orientation):

    for scenario in scenarios:
        for var in variables:              
            store_dir0 = store_dir.format(var,scenario)
            fig = plt.figure(figsize=fig_size)
            grid = gridspec.GridSpec(nrow,ncol,height_ratios=height_ratio,width_ratios=width_ratio,\
                                     wspace=wspace,hspace=hspace)
            var_name = var_names[var]
            for idx,season in enumerate(seasons):
                ax = fig.add_subplot(grid[idx])
                source_dir = parent_dir.format(scenario,var,season)
                plot_basemap(source_dir,var_name,border,cmap,vmin,vmax)
                ax.text(0.97, 0.97, season, verticalalignment='top', horizontalalignment='right',
                    transform=ax.transAxes, color='black', fontsize=text_size)
            var_min,var_max = get_vmin_vmax_seasonal(parent_dir,var,var_names,scenario,seasons)
#            print var_min,var_max
            extend = cbar_extend((vmin,vmax),(var_min,var_max))
            unit = cbar_unit(var)
            plot_colorbar(var,vmin,vmax,cbar_cax,cmap,cbar_tick_size,cbar_label_size,unit,orientation,extend)
	    suptitle="Seasonal Mean {} \n ({:0.4f},{:0.4f})".format(var,var_min,var_max)
	    fig.suptitle(suptitle,fontsize=18)
            fig.savefig(store_dir0,dpi=300)


if __name__=="__main_":
	print "Only functions"
