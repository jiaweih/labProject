#/usr/bin/python
### following are functions used in plotting timeseries of four regions of western U.S.

from cdo import *
from mpl_toolkits.basemap import Basemap, cm
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import datetime as dt
from netCDF4 import date2num, num2date
import pandas as pd
import pandas.stats.moments as pds
import os
from functions_common import plot_basemap,cbar_extend,plot_colorbar,cbar_unit

###calculate the water month of input calendar month
def water_month(indate):
    moy = indate
    if moy >= 10:
        outmonth = moy - 10
    else:
        outmonth = moy + 2
    return outmonth

### read the netCDF data
### data are timeseries, outputs are dataframe, with the index being time
def get_data_ts(ifile,start=None,end=None,timname='Time'):
    if os.path.exists(ifile):
   	 nc = Dataset(ifile,'r')
    else:
	 sys.exit('No such file:{}'.format(ifile))
    for key in nc.variables.keys():
        if key not in nc.dimensions.keys():
            var = key
    time =  num2date(nc.variables[timname][:],
                     nc.variables[timname].units,
                     nc.variables[timname].calendar)
    df = pd.Series(nc.variables[var][:,0,0],index = time)
    nc.close()
    if start:
        df = df[start:]
    if end:
        df = df[:end]
    return df

###calculate the maximum and minimum of data, which are timeseries
def get_vmin_vmax_ts(ifile,start,end):
    df = get_data_ts(ifile)
    vmin = np.floor(df.min())
    vmax = np.ceil(df.max())
    return (vmin,vmax)


### return the unit of variables
def get_yunit(var):
    if var == 'SOIL_MOIST' or var == 'SWE':
        y_unit = '(mm)'
    elif var == 'TMAX' or var == 'TMIN' or var == 'TAVG':
        y_unit = ' ($^\circ$C)'
    else:
        y_unit = ' (mm/day)'
    return y_unit

### return the variable names of variables
def get_var_name(var):
    var_names={'RUNOFF':'Runoff','PREC':'Precipitation','EVAP':'Evaporation','BASEFLOW':'Baseflow','FLOW':'Flow',
               'TMAX':'Tmax','TMIN':'Tmin','SWE':'SWE','SOIL_MOIST':'Soil Moisture'}
    return var_names[var]

### plot the monthly mean of input data, moving average is also plotted
def figure_monthly_mean(plot_dir,scenarios,variables,positions,start,end,fig_size,fmt_mean,fmt_smoothing,smoothing_step,linewidth,\
                        linewidth_moving,legend_loc,legend_size,xlabel,ymin_limit,ymax_limit,label_size,tick_size,height_ratio,width_ratio,wspace,hspace,store_dir_monthly_mean0,pos_names):
    for scenario in scenarios:
        for var in variables:
            y_unit=get_yunit(var)           
            ylabel = get_var_name(var)  
            grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
            fig = plt.figure(figsize=(fig_size))
            store_dir = store_dir_monthly_mean0.format(scenario,var)
            for idx,pos in enumerate(positions):    
                pos_name = pos_names[idx]
                file_fldmean = plot_dir.format(scenario,var,pos_name) 
                fig_txt_mean = pos_name + ' Monthly Mean ' + '(' + scenario + ')'   
                fig_txt_smoothing = '{} Months Moving Average'.format(smoothing_step)
                ax = fig.add_subplot(grid[idx])
                df = get_data_ts(file_fldmean,start,end)
                df.plot(style=fmt_mean,label=fig_txt_mean)
                pds.rolling_mean(df,smoothing_step,center=True).plot(style=fmt_smoothing,label=fig_txt_smoothing,linewidth=linewidth_moving)
                ax.legend(loc=legend_loc,prop={'size':legend_size})
                ax.set_xlabel(xlabel,fontsize=label_size)
                ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
                ax.set_ylim([ymin_limit,ymax_limit])
                ax.tick_params(axis='both',which='major',labelsize=tick_size)   
            fig.savefig(store_dir,dpi=300)  


### plot the monthly mean of historical and future timeseries, a line dividing the two periods will be plotted
def figure_monthly_mean_cat(plot_dir,scenarios,variables,positions,start,end,fig_size,fmt_mean,fmt_smoothing,smoothing_step,linewidth,\
                        linewidth_moving,legend_loc,legend_size,xlabel,ymin_limit,ymax_limit,label_size,tick_size,height_ratio,width_ratio,
                        wspace,hspace,store_dir_monthly_mean0,pos_names,linewidth_axv,color_axv):
    for scenario in scenarios:
        for var in variables:
            y_unit=get_yunit(var)
            ylabel = get_var_name(var)
            grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
            fig = plt.figure(figsize=(fig_size))
            store_dir = store_dir_monthly_mean0.format(scenario,var)
            for idx,pos in enumerate(positions):
                pos_name = pos_names[idx]
                file_fldmean = plot_dir.format(scenario,var,pos_name)
                fig_txt_mean = pos_name + ' Monthly Mean '  
                fig_txt_smoothing = '{} Months Moving Average'.format(smoothing_step)
                ax = fig.add_subplot(grid[idx])
                df = get_data_ts(file_fldmean,start,end)
                df.plot(style=fmt_mean,label=fig_txt_mean)
                pds.rolling_mean(df,smoothing_step,center=True).plot(style=fmt_smoothing,label=fig_txt_smoothing,linewidth=linewidth_moving)
                div=dt.datetime(2005,12,31)
                ax.axvline(x=div,linewidth=linewidth_axv,color=color_axv)
                ax.legend(loc=legend_loc,prop={'size':legend_size})
                ax.set_xlabel(xlabel,fontsize=label_size)
                ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
                ax.set_ylim([ymin_limit,ymax_limit])
                ax.tick_params(axis='both',which='major',labelsize=tick_size)
            fig.savefig(store_dir,dpi=300)


### plot annual mean of timeseries and moving average
def figure_annual_mean(plot_dir,scenarios,variables,positions,start,end,fig_size,fmt_mean,fmt_smoothing,smoothing_step,\
                     linewidth,linewidth_moving,legend_loc,legend_size,xlabel,ymin_limit,ymax_limit,label_size,tick_size,\
                     height_ratio,width_ratio,wspace,hspace,store_dir_annual_mean0,pos_names):
    for scenario in scenarios:
        for var in variables:
            y_unit=get_yunit(var)       
            ylabel = get_var_name(var) 
            grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
            fig = plt.figure(figsize=(fig_size))
            store_dir = store_dir_annual_mean0.format(scenario,var)
            for idx,pos in enumerate(positions):
                pos_name = pos_names[idx]
                file_fldmean = plot_dir.format(scenario,var,pos_name)                   
                #ymin_limit,ymax_limit= get_vmin_vmax(file_fldmean,None,None)     
                fig_txt_mean = pos_name + ' Annual Mean ' + '(' + scenario + ')'   
                fig_txt_smoothing = '{} Years Moving Average'.format(smoothing_step)
                ax = fig.add_subplot(grid[idx])          
                df = get_data_ts(file_fldmean,start,end)
                df.resample('A',how='mean').plot(style=fmt_mean,label=fig_txt_mean)
                df_mean = df.resample('A',how='mean')
                pds.rolling_mean(df_mean,smoothing_step,center=True).plot(style=fmt_smoothing,label=fig_txt_smoothing,linewidth=linewidth_moving)
                ax.legend(loc=legend_loc,prop={'size':legend_size})
                ax.set_xlabel(xlabel,fontsize=label_size)
                ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
                ax.set_ylim([ymin_limit,ymax_limit])
                ax.tick_params(axis='both',which='major',labelsize=tick_size)          
            fig.savefig(store_dir,dpi=300)


### plot annual mean of historical and future timeseries, a line dividing two periods will be plotted
def figure_annual_mean_cat(plot_dir,scenarios,variables,positions,start,end,fig_size,fmt_mean,fmt_smoothing,smoothing_step,\
                     linewidth,linewidth_moving,legend_loc,legend_size,xlabel,ymin_limit,ymax_limit,label_size,tick_size,\
                     height_ratio,width_ratio,wspace,hspace,store_dir_annual_mean0,pos_names,linewidth_axv,color_axv):
    for scenario in scenarios:
        for var in variables:
            y_unit=get_yunit(var)
            ylabel = get_var_name(var)
            grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
            fig = plt.figure(figsize=(fig_size))
            store_dir = store_dir_annual_mean0.format(scenario,var)
            for idx,pos in enumerate(positions):
                pos_name = pos_names[idx]
                file_fldmean = plot_dir.format(scenario,var,pos_name)
                #ymin_limit,ymax_limit= get_vmin_vmax(file_fldmean,None,None)     
		#print file_fldmean
                fig_txt_mean = pos_name + ' Annual Mean ' 
                fig_txt_smoothing = '{} Years Moving Average'.format(smoothing_step)
                ax = fig.add_subplot(grid[idx])
                df = get_data_ts(file_fldmean,start,end)
                df.resample('A',how='mean').plot(style=fmt_mean,label=fig_txt_mean)
                df_mean = df.resample('A',how='mean')
                pds.rolling_mean(df_mean,smoothing_step,center=True).plot(style=fmt_smoothing,label=fig_txt_smoothing,linewidth=linewidth_moving)
                div=dt.datetime(2005,12,31)
                ax.axvline(x=div,linewidth=linewidth_axv,color=color_axv)
                ax.legend(loc=legend_loc,prop={'size':legend_size})
                ax.set_xlabel(xlabel,fontsize=label_size)
                ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
                ax.set_ylim([ymin_limit,ymax_limit])
                ax.tick_params(axis='both',which='major',labelsize=tick_size)
            fig.savefig(store_dir,dpi=300)

### plot mean monthly of timeseries, x axis are from Oct to Sep
def figure_mean_monthly(plot_dir,scenarios,variables,positions,start,end,fig_size,fmt,
                    linewidth,legend_loc,legend_size,xlabel,ymin_limit,ymax_limit,label_size,
                    tick_size,height_ratio,width_ratio,wspace,hspace,store_dir_mean_average0,pos_names):
    monthes=['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep']
    for scenario in scenarios:
        for var in variables:
            y_unit=get_yunit(var)
            grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
            fig = plt.figure(figsize=(fig_size))
            store_dir = store_dir_mean_average0.format(scenario,var)          
            ylabel = get_var_name(var) 
            for idx,pos in enumerate(positions):
                pos_name = pos_names[idx]                             
                file_fldmean = plot_dir.format(scenario,var,pos_name)
                fig_txt = pos_name + ' Mean Monthly' + '(' + scenario + ')'
                ax = fig.add_subplot(grid[idx])
                df = get_data_ts(file_fldmean,start,end)
                df.groupby(lambda x: water_month(x.month)).mean().plot(style=fmt,label=fig_txt)
                ax.legend(loc=legend_loc,prop={'size':legend_size})
                ax.set_xlabel(xlabel,fontsize=label_size)
                ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
                ax.set_ylim([ymin_limit,ymax_limit])
                ax.set_xticks(np.arange(12))
                ax.set_xlim([-0.5,11.5])
                ax.set_xticklabels(monthes)
                ax.tick_params(axis='both',which='major',labelsize=tick_size) 
            fig.savefig(store_dir,dpi=300)

### mean monthly of historical, rcp45, rcp85 are plotted on the same figure
def figure_mean_monthly_together(plot_dir,scenarios,variables,positions,ymin_limit,ymax_limit,start,end,fig_size,fmts,\
                              linewidth,legend_loc,legend_size,xlabel,label_size,tick_size,height_ratio,
                              width_ratio,wspace,hspace,text_size,pos_names,store_dir_mean_average_together0):
    for var in variables:
        y_unit = get_yunit(var)  
        ylabel = get_var_name(var)
        grid = gridspec.GridSpec(2,2,height_ratios=height_ratio,width_ratios=width_ratio,wspace=wspace,hspace=hspace)
        fig = plt.figure(figsize=(fig_size))
        store_dir = store_dir_mean_average_together0.format(var)
        monthes=['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep']
        for idx,pos in enumerate(positions):
            ax = fig.add_subplot(grid[idx])
            pos_name = pos_names[idx]
            for idy,scenario in enumerate(scenarios):                               
                file_fldmean = plot_dir.format(scenario,var,pos_name) 
                fmt = fmts[idy]
                fig_txt = scenario
                monthes=['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep']
                df = get_data_ts(file_fldmean,start,end)
                df.groupby(lambda x: water_month(x.month)).mean().plot(style=fmt,label=fig_txt)
            ax.legend(loc=legend_loc,prop={'size':legend_size})
            ax.set_xlabel(xlabel,fontsize=label_size)
            ax.set_ylabel(ylabel+y_unit,fontsize=label_size)
            ax.set_ylim([ymin_limit,ymax_limit])
            ax.set_xticks(np.arange(12))
            ax.set_xlim([-0.5,11.5])
            ax.set_xticklabels(monthes)
            ax.tick_params(axis='both',which='major',labelsize=tick_size)
            ax.text(0.08, 0.97, pos_name, verticalalignment='top', horizontalalignment='left',
                        transform=ax.transAxes, color='black', fontsize=text_size)
        fig.savefig(store_dir,dpi=300)
