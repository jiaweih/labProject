#!/bin/bash

inpath=/home/raid9/homefc/conus/data.sets/CRU/clip/mask
outpath=/raid3/jiawei/homero/data/cru
fn0=`printf "cru_ts3.21.1901.2012.???.mask.nc"`
fn01=`printf "cru_ts3.21.1901.2012.pre.mask.nc"`
fn02=`printf "cru_ts3.21.1901.2012.tmn.mask.nc"`
fn03=`printf "cru_ts3.21.1901.2012.tmx.mask.nc"`
fn1=`printf "cru.1901.2012.nc"`
fn2=`printf "cru.rename.1901.2012.nc"`
fn3=`printf "cru.rename.1915.2011.nc"`
fn4=`printf "cru.1915.2011.nc"`

#concatenate three variables in three separate datasets into one single dataset
ncks -A $inpath/$fn01 $outpath/$fn1
ncks -A $inpath/$fn02 $outpath/$fn1
ncks -A $inpath/$fn03 $outpath/$fn1

#change the variable names to "standard" names
cp $outpath/$fn1 $outpath/$fn2
ncrename -v pre,Prec $outpath/$fn2
ncrename -v tmx,Tmax $outpath/$fn2
ncrename -v tmn,Tmin $outpath/$fn2

#extract the time periods that match those of Livneh datasets
ncea -F -d time,169,1332 $outpath/$fn2 $outpath/$fn3

#calculate daily precipitation, since the original dataset has monthly precipitation
ncap2 -s Prec=Prec/30.0 $outpath/$fn3 $outpath/$fn4
