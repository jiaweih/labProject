from mpl_toolkits.basemap import Basemap, cm
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt

plt.subplot(223)
nc=Dataset('/home/raid3/jiawei/homero/swm/data.diff/seasonalmean/seasonalmean/data.1951_2004.Tmax.Autumn.nc')
precip=nc.variables['Tmax']
data=precip[0][:]
lon=nc.variables['lon'][:]
lat=nc.variables['lat'][:]

m = Basemap(projection='merc',llcrnrlat=25.25,urcrnrlat=49.25,\
llcrnrlon=-124.75,urcrnrlon=-67.25,lat_ts=30,resolution='c')
m.drawcoastlines(linewidth=0.25)
#m.fillcontinents(color='coral',lake_color='aqua')
#m.drawmapboundary(fill_color='aqua')
#xi, yi = m(lon, lat)
xi, yi = m(*np.meshgrid(lon, lat))
cs = m.contourf(xi,yi,data,levels = range(-8,10,2),cmap=plt.cm.jet)
cbar = m.colorbar(cs,location='bottom',pad="5%")
#cbar.set_label('Cbar')
#cbar.set_label('mm')
cbar.ax.tick_params(labelsize=9)
plt.title('Autumn', fontsize=15)
cbar.set_label('Tmax (C)')
plt.subplot(222)
nc=Dataset('/home/raid3/jiawei/homero/swm/data.diff/seasonalmean/seasonalmean/data.1951_2004.Tmax.Summer.nc')
precip=nc.variables['Tmax']
data=precip[0][:]
lon=nc.variables['lon'][:]
lat=nc.variables['lat'][:]

m = Basemap(projection='merc',llcrnrlat=25.25,urcrnrlat=49.25,\
llcrnrlon=-124.75,urcrnrlon=-67.25,lat_ts=30,resolution='c')
m.drawcoastlines(linewidth=0.25)
#m.fillcontinents(color='coral',lake_color='aqua')
#m.drawmapboundary(fill_color='aqua')
#xi, yi = m(lon, lat)
xi, yi = m(*np.meshgrid(lon, lat))
cs = m.contourf(xi,yi,data,levels = range(-8,10,2),cmap=plt.cm.jet)
cbar = m.colorbar(cs,location='bottom',pad="5%")
#cbar.set_label('Cbar')
cbar.set_label('Tmax (C)')
cbar.ax.tick_params(labelsize=9)
#cbar.set_label('mm')
plt.title('Summer', fontsize=15)

plt.subplot(224)
nc=Dataset('/home/raid3/jiawei/homero/swm/data.diff/seasonalmean/seasonalmean/data.1951_2004.Tmax.Winter.nc')
precip=nc.variables['Tmax']
data=precip[0][:]
lon=nc.variables['lon'][:]
lat=nc.variables['lat'][:]

m = Basemap(projection='merc',llcrnrlat=25.25,urcrnrlat=49.25,\
llcrnrlon=-124.75,urcrnrlon=-67.25,lat_ts=30,resolution='c')
m.drawcoastlines(linewidth=0.25)
#m.fillcontinents(color='coral',lake_color='aqua')
#m.drawmapboundary(fill_color='aqua')
#xi, yi = m(lon, lat)
xi, yi = m(*np.meshgrid(lon, lat))
cs = m.contourf(xi,yi,data,levels = range(-8,10,2),cmap=plt.cm.jet)
cbar = m.colorbar(cs,location='bottom',pad="5%")
#cbar.set_label('Cbar')
cbar.set_label('Tmax (C)')
cbar.ax.tick_params(labelsize=9)
plt.title('Winter', fontsize=15)

plt.subplot(221)
nc=Dataset('/home/raid3/jiawei/homero/swm/data.diff/seasonalmean/seasonalmean/data.1951_2004.Tmax.Spring.nc')
precip=nc.variables['Tmax']
data=precip[0][:]
lon=nc.variables['lon'][:]
lat=nc.variables['lat'][:]

m = Basemap(projection='merc',llcrnrlat=25.25,urcrnrlat=49.25,\
llcrnrlon=-124.75,urcrnrlon=-67.25,lat_ts=30,resolution='c')
m.drawcoastlines(linewidth=0.25)
#m.fillcontinents(color='coral',lake_color='aqua')
#m.drawmapboundary(fill_color='aqua')
#xi, yi = m(lon, lat)
xi, yi = m(*np.meshgrid(lon, lat))
cs = m.contourf(xi,yi,data,levels = range(-8,10,2),cmap=plt.cm.jet)
cbar = m.colorbar(cs,location='bottom',pad="5%")
cbar.set_label('Tmax (C)')
cbar.ax.tick_params(labelsize=9)
#cbar.set_label('Cbar')
#cbar.set_label('mm')
plt.title('Spring', fontsize=15)

plt.show()
