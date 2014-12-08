#!/bin/bash

inpath=/raid3/jiawei/homero/data/maurer
outpath=/raid3/jiawei/homero/data/maurer

fn1=`printf "maurer.1950.1999.nc"`
fn2=`printf "livneh.1950.1999.nc"`
fn3=`printf "livneh.remapMaurer.nc"`
fn4=`printf "maurer.diff.nc"`
fn5=`printf "maurer.seasmean.nc"`
fn6=`printf "maurer.Summer.nc"`
fn7=`printf "maurer.Autumn.nc"`
fn8=`printf "maurer.Winter.nc"`
fn9=`printf "maurer.Spring.nc"`

#transform the grids of Livneh to the same grids as Maurer
cdo remapcon,$inpath/$fn1 $inpath/$fn2 $inpath/$fn3

#calculate the differences
ncbo -v Prec,Tmax,Tmin $inpath/$fn1 $inpath/$fn3 $outpath/$fn4

#calculate seasonal mean
cdo seasmean $inpath/$fn4 $outpath/$fn5

#aggreate the same seasonal values
ncra -F -d time,2,200,4 $inpath/$fn5 $outpath/$fn6
ncra -F -d time,3,200,4 $inpath/$fn5 $outpath/$fn7
ncra -F -d time,4,200,4 $inpath/$fn5 $outpath/$fn8
ncra -F -d time,5,200,4 $inpath/$fn5 $outpath/$fn9


