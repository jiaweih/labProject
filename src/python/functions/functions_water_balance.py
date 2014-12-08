#/usr/bin/python
### Following are functions used in plotting water balance error.

from mpl_toolkits.basemap import Basemap, cm
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy.ma as ma
import matplotlib as mpl
import os


def get_data(ifile):
    nc = Dataset(ifile,'r')
    for key in nc.variables.keys():
        if key not in nc.dimensions.keys():
            var = key
    return nc.variables[var][:]

def read_lon_lat(ifile):
    nc = Dataset(ifile,'r')
    return (nc.variables['Longitude'][:],nc.variables['Latitude'][:])   

def read_filename(dir_path):
    dirs_vars = [line.strip() for line in open(dir_path)]
    dirs=[]
    signs=[]
    var_names=[]
    len_var=len(dirs_vars)  
    for ix in np.arange(0,len_var):
        t = dirs_vars[ix].split(' ')
        var_names.append(t[0])
        signs.append(float(t[1]))  
        dirs.append(t[2])
    return (len_var,var_names,signs,dirs)


def get_map_lon_lat(dirs):
    data0 = get_data(dirs[0])
    shape = np.shape(data0)
    register = np.zeros((1,shape[1],shape[2]))
    lon,lat = read_lon_lat(dirs[0])
    return (lon,lat,register)


def get_error_over_prec(len_var,var_names,signs,dirs,error):
    for idx in np.arange(0,len_var):
        data = get_data(dirs[idx])
        mask = ma.getmaskarray(data)
        if var_names[idx] == 'PREC':
            Prec = signs[idx]*ma.masked_array(data,mask)
        error+=data*signs[idx]
    error_m = ma.masked_array(error,mask)
    error_over_Prec = error_m/Prec
    return (error_m[0],error_over_Prec[0])

def get_error_extreme(len_var,var_names,signs,dirs,error):
    for idx in np.arange(0,len_var):
        data = get_data(dirs[idx])
        mask = ma.getmaskarray(data)
        if var_names[idx] == 'PREC':
            Prec = signs[idx]*ma.masked_array(data,mask)
        error+=data*signs[idx]
    error_m = ma.masked_array(error,mask)
    error_over_Prec = error_m/Prec
    return np.unravel_index(error_m[0].argmax(),error_m[0].shape)


def get_storage_over_prec(len_var,var_names,signs,dirs,storage):
    for idx in np.arange(0,len_var):
        data = get_data(dirs[idx])
        if var_names[idx] == 'PREC':
            Prec = data*signs[idx]
        else:
            storage+=data*signs[idx]
    mask = ma.getmaskarray(data)
    storage_m = ma.masked_array(storage,mask)
    Prec_m = ma.masked_array(Prec,mask)
    storage_over_Prec = storage_m/Prec_m
    return (storage_m[0],storage_over_Prec[0])


def get_storage_change(len_var,var_names,signs,dirs,storage):
    for idx in np.arange(0,len_var):
        data = get_data(dirs[idx])
        storage+=data*signs[idx]
    mask = ma.getmaskarray(data)
    storage_change = ma.masked_array(storage,mask)
    return storage_change[0]


def plot_basemap(data,lon,lat,border,vmin,vmax,cmap):
    latmi   = np.min(lat)-border
    latmx   = np.max(lat)+border
    latmean = (latmi+latmx)/2.
    lonmi   = np.min(lon)-border
    lonmx   = np.max(lon)+border
    lonmean = (lonmi+lonmx)/2.
    m = Basemap(projection = 'merc',lat_0=latmean, lon_0=lonmean, llcrnrlat=latmi,
            urcrnrlat=latmx, llcrnrlon=lonmi, urcrnrlon=lonmx, resolution='i')
    m.drawcoastlines(linewidth=0.25)
    xi,yi = m(*np.meshgrid(lon,lat))
    cs = m.pcolormesh(xi,yi,data,vmin=vmin,vmax=vmax,cmap=cmap)


def plot_colorbar(data,cbar_name,vmin,vmax,cax,cmap,tick_size,label_size,cbar_unit,orientation,extend):
    norm = mpl.colors.Normalize(vmin,vmax)
    cax = plt.axes(cax)
    cbar = mpl.colorbar.ColorbarBase(cax,cmap=cmap,norm=norm,orientation=orientation,extend=extend)
    cbar.ax.tick_params(labelsize=tick_size)
    cbar.set_label(cbar_name + cbar_unit, fontsize = label_size)


def plot_figure_water_balance(dir_balance,store_dir,fig_size,border,fig_text1,fig_text2,cbar_name1,cbar_name2,vmin,vmax,\
                cax1,cax2,cmap,tick_size,label_size,text_size,cbar_unit1,cbar_unit2,orientation,extend):
    fig = plt.figure(figsize=fig_size)
    grid = gridspec.GridSpec(1, 2, height_ratios=[10,.5], hspace=0.0,wspace=0.4)
    len_var,var_names,signs,dirs = read_filename(dir_balance)
    lon,lat,error = get_map_lon_lat(dirs) 
    error_m,error_over_Prec = get_error_over_prec(len_var,var_names,signs,dirs,error)
    
    ax = fig.add_subplot(grid[0])
    plot_basemap(error_m,lon,lat,border,vmin,vmax,cmap)
    cax = plt.axes(cax1)
    plot_colorbar(error_m,cbar_name1,vmin,vmax,cax,cmap,tick_size,label_size,cbar_unit1,orientation,extend)
    ax.text(0.98, 0.98, fig_text1, verticalalignment='top', horizontalalignment='right',
            transform=ax.transAxes, color='black', fontsize=text_size)
    
    ax = fig.add_subplot(grid[1])
    plot_basemap(error_over_Prec*100,lon,lat,border,vmin,vmax,cmap)
    vmin=-0.1
    vmax=0.1
    cax = plt.axes(cax2)
    plot_colorbar(error_over_Prec*100,cbar_name2,vmin,vmax,cax,cmap,tick_size,label_size,cbar_unit2,orientation,extend)
    ax.text(0.97, 0.98, fig_text2, verticalalignment='top', horizontalalignment='right',
            transform=ax.transAxes, color='black', fontsize=text_size)

    fig.savefig(store_dir,dpi=300)


def plot_figure_storage_change(dir_storage,store_dir,lon,lat,fig_size,border,fig_text1,fig_text2,cbar_name1,cbar_name2,vmin,vmax,\
                cax1,cax2,cmap,tick_size,label_size,text_size,cbar_unit1,cbar_unit2,orientation,extend):
    fig = plt.figure(figsize=fig_size)
    grid = gridspec.GridSpec(1, 2, height_ratios=[10,.5], hspace=0.0,wspace=0.4)
    len_var,var_names,signs,dirs = read_filename(dir_storage)
    lon,lat,error = get_map_lon_lat(dirs)
    error_m,error_over_Prec = get_storage_over_prec(len_var,var_names,signs,dirs,error)

    ax = fig.add_subplot(grid[0])
    plot_basemap(error_m,lon,lat,border,vmin,vmax,cmap)
    cax = plt.axes(cax1)
    plot_colorbar(error_m,cbar_name1,vmin,vmax,cax,cmap,tick_size,label_size,cbar_unit1,orientation,extend)
    ax.text(0.98, 0.98, fig_text1, verticalalignment='top', horizontalalignment='right',
            transform=ax.transAxes, color='black', fontsize=text_size)

    ax = fig.add_subplot(grid[1])
    plot_basemap(error_over_Prec*100,lon,lat,border,vmin,vmax,cmap)
    vmin=-0.1
    vmax=0.1
    cax = plt.axes(cax2)
    plot_colorbar(error_over_Prec*100,cbar_name2,vmin,vmax,cax,cmap,tick_size,label_size,cbar_unit2,orientation,extend)
    ax.text(0.97, 0.98, fig_text2, verticalalignment='top', horizontalalignment='right',
            transform=ax.transAxes, color='black', fontsize=text_size)

    fig.savefig(store_dir,dpi=300)
