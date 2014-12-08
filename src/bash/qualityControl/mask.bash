#!/bin/bash

#The scripts aim to create CRU dataset from the mask file obtained from Maurer's dataset.

#path to each dataset 
idir=/raid2/homefc/conus/data.sets/Maurer
odir=/raid3/jiawei/homero/cru/mask/Prec
idir2=/raid2/homefc/conus/data.sets/CRU

#one of Maurer's dataset used to create a mask file
fn1=`printf "gridded_obs.monthly.Prcp.1991.nc"`

#mask file created from the dataset above
fn2=`printf "test.nc"` 

#mask file of precipitation by averaging preci over time
fn3=`printf "mask_pre.nc"` 

#CRU dataset in a global sca
fn4=`printf "cru_ts3.21.1901.2012.pre.dat.nc"` 

#dataset clipped from global dataset
fn5=`printf "cru_ts3.21.1901.2012.pre.clip.nc"` 

#targeted dataset derived from clipped dataset and mask file of Maurer dataset
fn6=`printf "cru_ts3.21.1901.2012.pre.mask.nc"` 

#clip parts of global map
#considering the grid of original dataset, the domain will probably not be exactly specified.
ncks -d lat,25.1875,52.8125 -d lon,-124.688,-67.0625 $idir2/$fn4 $odir/$fn5

#remap the grid of Maurer to that of CRU
#<operator>,ifile1 ifile2 ofile
cdo remapcon,$odir/$fn5 $idir/$fn1 $odir/$fn1

#create a mask file based on one of Maurer's dataset
#<operator>,c ifile ofile
cdo gtc,0.0 $odir/$fn1 $odir/$fn2

#Eliminate time dimension by averaging precipitation of mask file over time 
ncwa -O -v Prcp -a time $odir/$fn2 $odir/$fn3

#create a dataset of CRU based on the mask file of Maurer's
#<operator> ifile1 ifile2 ofile
cdo ifthen $odir/$fn3 $odir/$fn5 $odir/$fn6

