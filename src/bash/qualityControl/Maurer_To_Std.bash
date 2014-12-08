#!/bin/bash

inpath1=/home/raid9/homefc/conus/data.sets/Maurer
outpath=/raid3/jiawei/homero/data/maurer
inpath2=/home/raid9/homefc/conus/data.sets/Livneh_PRISM

fn0=`printf "data.191501_201112.nc"`
fn1=`printf "gridded_obs.monthly.Prcp.????.nc"`
fn2=`printf "gridded_obs.monthly.Tmax.????.nc"`
fn3=`printf "gridded_obs.monthly.Tmin.????.nc"`
fn4=`printf "maurer.1950.1999.Prec.nc"`
fn5=`printf "maurer.1950.1999.Tmax.nc"`
fn6=`printf "maurer.1950.1999.Tmin.nc"`
fn7=`printf "maurer.1950.1999.temp.nc"`
fn8=`printf "livneh.1950.1999.nc"`
fn9=`printf "maurer.1950.1999.nc"`

#concatenate datasets with the same variables
ncrcat $inpath1/$fn1 $outpath/$fn4
ncrcat $inpath1/$fn2 $outpath/$fn5
ncrcat $inpath1/$fn3 $outpath/$fn6

#concatenate all variables in one single dataset
ncks -A $outpath/$fn4 $outpath/$fn7
ncks -A $outpath/$fn5 $outpath/$fn7
ncks -A $outpath/$fn6 $outpath/$fn7

#change variable name to "standard" names
ncrename -v Prcp,Prec -v latitude,lat -v longitude,lon $outpath/$fn7
ncrename -d latitude,lat -d longitude,lon $outpath/$fn7
ncks -O -x -v bounds_latitude,bounds_longitude $outpath/$fn7 $outpath/$fn9

#extract parts of Livneh data to match that of Maurer 1950-1999
ncea -F -d time,421,1020 $inpath2/$fn0 $outpath/$fn8
