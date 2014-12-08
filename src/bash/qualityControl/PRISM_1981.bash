#!/bin/bash

input=/raid2/homefc/conus/data.sets/Livneh_PRISM
output=/raid3/jiawei/homero/data/prism/livneh
input1=/raid3/jiawei/homero/data/prism/ppt
input2=/raid3/jiawei/homero/data/prism/tmax
input3=/raid3/jiawei/homero/data/prism/tmin

fn1=`printf "data.191501_201112.nc"`
fn2=`printf "data.195001_201112.nc"`
fn3=`printf "data.1950.2011.nc"`
fn4=`printf "data.Prec.nc"`
fn5=`printf "data.Tmax.nc"`
fn6=`printf "data.Tmin.nc"`
fn7=`printf "data.Prec.remap.nc"`
fn8=`printf "data.Tmax.remap.nc"`
fn9=`printf "data.Tmin.remap.nc"`
fn10=`printf "Prec_1981_2010.nc"`
fn11=`printf "Tmax_1981_2010.nc"`
fn12=`printf "Tmin_1981_2010.nc"`
fn13=`printf "data.Prec.diff.nc"`
fn14=`printf "data.Tmax.diff.nc"`
fn15=`printf "data.Tmin.diff.nc"`

#ncea -F -d time,421,1164 $input/$fn1 $output/$fn2

#ncap2 -s "Prec=Prec*30*12" $output/$fn2 $output/$fn3

#ncwa -O -v Prec -a time $output/$fn3 $output/$fn4
#ncwa -O -v Tmax -a time $output/$fn3 $output/$fn5
#ncwa -O -v Tmin -a time $output/$fn3 $output/$fn6

#cdo remapcon,$input1/$fn10 $output/$fn4 $output/$fn7
#cdo remapcon,$input2/$fn11 $output/$fn5 $output/$fn8
#cdo remapcon,$input3/$fn12 $output/$fn6 $output/$fn9

#cdo remapcon,$output/$fn4 $input1/$fn10 $output/$fn7
#cdo remapcon,$output/$fn5 $input2/$fn11 $output/$fn8
#cdo remapcon,$output/$fn6 $input3/$fn12 $output/$fn9

#ncdiff -v Prec $input1/$fn10 $output/$fn7 $output/$fn13
#ncdiff -v Tmax $input2/$fn11 $output/$fn8 $output/$fn14
#ncdiff -v Tmin $input3/$fn12 $output/$fn9 $output/$fn15

ncdiff -v Prec $output/$fn4 $output/$fn7 $output/$fn13
ncdiff -v Tmax $output/$fn5 $output/$fn8 $output/$fn14
ncdiff -v Tmin $output/$fn6 $output/$fn9 $output/$fn15
