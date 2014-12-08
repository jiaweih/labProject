#/usr/bin/python

### following are functions commonly used in plotting 

from mpl_toolkits.basemap import Basemap, cm
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib as mpl
import datetime as dt
from netCDF4 import date2num,num2date
import pandas as pd
import pandas.stats.moments as pds
import os

### read netCDF data, return data of variable, latitude and longitude
def get_data(infile,var_name,lat_name='Latitude',lon_name='Longitude'):
    nc = Dataset(infile,'r')
    lat = nc.variables[lat_name][:]
    lon = nc.variables[lon_name][:]
    var = nc.variables[var_name][:]
    nc.close()
    return (var[0],lat,lon)


### plot basemap of netCDF data
def plot_basemap(source_dir,var_name,border,cmap,vmin,vmax):
    var,lat,lon = get_data(source_dir,var_name)
    latmi   = min(lat)-border
    latmx   = max(lat)+border
    latmean = (latmi+latmx)/2.
    lonmi   = min(lon)-border
    lonmx   = max(lon)+border
    lonmean = (lonmi+lonmx)/2.
    m = Basemap(projection = 'merc',lat_0=latmean, lon_0=lonmean, llcrnrlat=latmi,
            urcrnrlat=latmx, llcrnrlon=lonmi, urcrnrlon=lonmx, resolution='i')
    m.drawcoastlines(linewidth=0.25)
    xi,yi = m(*np.meshgrid(lon,lat))
    norm = mpl.colors.Normalize(vmin,vmax)
    m.pcolormesh(xi,yi,var,cmap=cmap,norm=norm)

### determine the extend of colorbar, cbar_range is the range of colorbar displayed, data_range is the actual range of data
def cbar_extend(cbar_range,data_range):
    extend = None
    if cbar_range[0] == None:
        cbar_range[0] = data_range[0]
    if cbar_range[1] == None:
        cbar_range[1] == data_range[1]
    if data_range[0] < cbar_range[0]:
        extend = 'min'
    if data_range[1] > cbar_range[1]:
        if extend:
            extend = 'both'
        else:
            extend = 'max'
    if not extend:
        extend = 'neither'
    
    return extend


### plot colorbar
def plot_colorbar(var,vmin,vmax,cax,cmap,tick_size,label_size,unit,orientation,extend):
    norm = mpl.colors.Normalize(vmin,vmax)
    cax = plt.axes(cax)
    cbar = mpl.colorbar.ColorbarBase(cax,cmap=cmap,norm=norm,orientation=orientation,extend=extend)
    cbar.ax.tick_params(labelsize=tick_size)
    cbar.set_label(var + unit, fontsize = label_size)


### return the unit of variable on the colorbar
def cbar_unit(var):
    if var == 'SOIL_MOIST' or var == 'SWE':
        unit = ' (mm)'
    elif var == 'TMAX' or var == 'TMIN' or var == 'TAVG':
        unit = ' ($^\circ$C)'
    else:
        unit = ' (mm/day)'
    return unit

### return the variable name on the y-axis
def get_var_name(var):
    var_names={'RUNOFF':'Runoff','PREC':'Precipitation','EVAP':'Evaporation','BASEFLOW':'Baseflow','FLOW':'Flow',
               'TMAX':'Tmax','TMIN':'Tmin','SWE':'SWE','SOIL_MOIST':'Soil Moisture'}
    return var_names[var]
