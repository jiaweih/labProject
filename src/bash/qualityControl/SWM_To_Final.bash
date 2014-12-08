#!/bin/bash

inpath=/raid3/jiawei/homero/data/swm
inpath2=/raid3/jiawei/homero/data/livneh
inpath3=/home/raid9/homefc/conus/data.sets/Livneh_PRISM
outpath=/raid3/jiawei/homero/data/swm

fn0=`printf "data.191501_201112.nc"`
fn1=`printf "swm.191501_201112.nc"`
fn2=`printf "swm.diff.nc"`
fn3=`printf "swm.pre1950.diff.nc"`
fn4=`printf "swm.pos1950.diff.nc"`
fn5=`printf "swm.pre1950.seasmean.nc"`
fn6=`printf "swm.pos1950.seasmean.nc"`
fn7=`printf "swm.pre1950.Spring.nc"`
fn8=`printf "swm.pre1950.Summer.nc"`
fn9=`printf "swm.pre1950.Autumn.nc"`
fn10=`printf "swm.pre1950.Winter.nc"`
fn11=`printf "swm.pos1950.Spring.nc"`
fn12=`printf "swm.pos1950.Summer.nc"`
fn13=`printf "swm.pos1950.Autumn.nc"`
fn14=`printf "swm.pos1950.Winter.nc"`
fn15=`printf "livneh.remapSWM.nc"`


#transform the grids of Livneh dataset to the grids of SWM dataset
#cdo remapcon,$inpath/$fn1 $inpath3/$fn0 $inpath2/$fn15

#calculate the differences between Livneh dataset and SWM dataset
ncbo -v Prec,Tmax,Tmin $inpath/$fn1 $inpath2/$fn15 $outpath/$fn2

#split the dataset of the difference into pre1950 and pos1950
ncea -F -d time,1,432 $inpath/$fn2 $outpath/$fn3
ncea -F -d time,433,1164 $inpath/$fn2 $outpath/$fn4

#calculate the seasonal mean value of variables 
cdo seasmean $inpath/$fn3 $outpath/$fn5
cdo seasmean $inpath/$fn4 $outpath/$fn6

#put dataset of same season together in one dataset
ncra -F -d time,2,144,4 $inpath/$fn5 $outpath/$fn8
ncra -F -d time,3,144,4 $inpath/$fn5 $outpath/$fn9
ncra -F -d time,4,144,4 $inpath/$fn5 $outpath/$fn10
ncra -F -d time,5,144,4 $inpath/$fn5 $outpath/$fn7

ncra -F -d time,2,144,4 $inpath/$fn6 $outpath/$fn12
ncra -F -d time,3,144,4 $inpath/$fn6 $outpath/$fn13
ncra -F -d time,4,144,4 $inpath/$fn6 $outpath/$fn14
ncra -F -d time,5,144,4 $inpath/$fn6 $outpath/$fn11


