#!/bin/bash

inpath1=/raid2/homefc/conus/data.sets/Livneh_noPRISM
inpath2=/raid2/homefc/conus/data.sets/L14
outpath=/raid3/jiawei/homero/data/livneh/livneh_vs_livneh/data

fn0=`printf "data.191501_201112.nc"` #file name for two datasets to be compared (two datasets are created by Livneh at different time, have the same file name)
fn1=`printf "livneh.diff.nc"`       #differences between two datasets

#before 1950 and after 1950 for datasets of differences
fn2=`printf "livneh.pre1950.diff.nc"`
fn3=`printf "livneh.pos1950.diff.nc"`

#datasets for seasonal mean value
fn4=`printf "livneh.pre1950.seasmean.diff.nc"`
fn5=`printf "livneh.pos1950.seasmean.diff.nc"`

#mean value for each season before 1950
fn6=`printf "livneh.pre1950.Spring.nc"`
fn7=`printf "livneh.pre1950.Summer.nc"`
fn8=`printf "livneh.pre1950.Autumn.nc"`
fn9=`printf "livneh.pre1950.Winter.nc"`

#mean value for each season after 1950
fn10=`printf "livneh.pos1950.Spring.nc"`
fn11=`printf "livneh.pos1950.Summer.nc"`
fn12=`printf "livneh.pos1950.Autumn.nc"`
fn13=`printf "livneh.pos1950.Winter.nc"`


#calculate the differences between Livneh datasets
ncbo -v Prec,Tmax,Tmin $inpath1/$fn0 $inpath1/$fn0 $outpath/$fn1

#split the dataset of the difference into pre1950 and pos1950
ncea -F -d time,1,432 $outpath/$fn1 $outpath/$fn2
ncea -F -d time,433,1164 $outpath/$fn1 $outpath/$fn3

#calculate the seasonal mean value of variables 
cdo seasmean $outpath/$fn2 $outpath/$fn4
cdo seasmean $outpath/$fn3 $outpath/$fn5


#put dataset of same season together in one dataset
ncra -F -d time,2,144,4 $outpath/$fn4 $outpath/$fn7
ncra -F -d time,3,144,4 $outpath/$fn4 $outpath/$fn8
ncra -F -d time,4,144,4 $outpath/$fn4 $outpath/$fn9
ncra -F -d time,5,144,4 $outpath/$fn4 $outpath/$fn6

ncra -F -d time,2,144,4 $outpath/$fn5 $outpath/$fn11
ncra -F -d time,3,144,4 $outpath/$fn5 $outpath/$fn12
ncra -F -d time,4,144,4 $outpath/$fn5 $outpath/$fn13
ncra -F -d time,5,144,4 $outpath/$fn5 $outpath/$fn10


