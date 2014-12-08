#!/bin/bash

#This script aims to "standardize" CRU netCDF format;putting three datasets for precipitation,Tmax,Tmin together;converting variable names to Prec,Tmax,Tmin;extracting parts of original data to match the time period of Livneh data.

inpath=/raid3/jiawei/homero/cru/mask
outpath=/raid3/jiawei/homero/data/cru/L14

cru_o=`printf "cru_ts3.21.1901.2012.???.mask.nc"`
cru_pre=`printf "cru_ts3.21.1901.2012.pre.mask.nc"`
cru_tmn=`printf "cru_ts3.21.1901.2012.tmn.mask.nc"`
cru_tmx=`printf "cru_ts3.21.1901.2012.tmx.mask.nc"`
cru_1901_2012=`printf "cru.1901.2012.nc"`  #data for three variables in one dataset
cru_rename_1901_2012=`printf "cru.rename.1901.2012.nc"`
cru_rename_1915_2011=`printf "cru.rename.1915.2011.nc"`  #CRU dataset with the same period as Livneh's
cru_1915_2011=`printf "cru.1915.2011.nc"` #final dataset with the same variable name, same time period, same units as Livneh's

#concatenate three variables in three separate datasets into one single dataset
ncks -A $inpath/$cru_pre $outpath/$cru_1901_2012
ncks -A $inpath/$cru_tmn $outpath/$cru_1901_2012
ncks -A $inpath/$cru_tmx $outpath/$cru_1901_2012

#change the variable names to "standard" names
cp $outpath/$cru_1901_2012 $outpath/$cru_rename_1901_2012
ncrename -v pre,Prec $outpath/$cru_rename_1901_2012
ncrename -v tmx,Tmax $outpath/$cru_rename_1901_2012
ncrename -v tmn,Tmin $outpath/$cru_rename_1901_2012

#extract the time periods that match those of Livneh datasets
ncea -F -d time,169,1332 $outpath/$cru_rename_1901_2012 $outpath/$cru_rename_1915_2011

#calculate daily precipitation, since the original dataset has monthly precipitation
ncap2 -s Prec=Prec/30.0 $outpath/$cru_rename_1915_2011 $outpath/$cru_1915_2011
