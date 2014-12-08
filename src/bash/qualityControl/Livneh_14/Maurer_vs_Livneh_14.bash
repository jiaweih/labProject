#!/bin/bash

##This script aims to compare Maurer dataset with Livneh dataset.
##Maurer dataset spans from 1950 to 1999 with 1/8 degrees;Livneh dataset spans
##from 1911 to 2011 with 1/16 degrees.

#Specify the directories
Maurer_original_path=/raid3/jiawei/homero/data/maurer
Livneh_original_path=/raid2/homefc/conus/data.sets/L14
Result_path=/raid3/jiawei/homero/data/maurer/L14

#Specify the filenames
Maurer_original=`printf "maurer.1950.1999.nc"`
Livneh_original=`printf "data.191501_201112.nc"`
Livneh_1950_1999=`printf "Livneh.1950.1999.nc"`
Livneh_remap=`printf "livneh.remapMaurer.nc"`
Diff=`printf "diff.nc"`
Seasmean=`printf "seasmean.nc"`
Summer=`printf "maurer.Summer.nc"`
Autumn=`printf "maurer.Autumn.nc"`
Winter=`printf "maurer.Winter.nc"`
Spring=`printf "maurer.Spring.nc"`

#extract parts of Livneh data to match that of Maurer 1950-1999
ncea -F -d time,421,1020 $Livneh_original_path/$Livneh_original $Result_path/$Livneh_1950_1999

#transform the grids of Livneh to the same grids as Maurer
cdo remapcon,$Maurer_original_path/$Maurer_original $Result_path/$Livneh_1950_1999 $Result_path/$Livneh_remap

#calculate the differences
ncbo -v Prec,Tmax,Tmin $Maurer_original_path/$Maurer_original $Result_path/$Livneh_remap $Result_path/$Diff

#calculate seasonal mean
cdo seasmean $Result_path/$Diff $Result_path/$Seasmean

#aggreate the same seasonal values
ncra -F -d time,2,200,4 $Result_path/$Seasmean $Result_path/$Summer
ncra -F -d time,3,200,4 $Result_path/$Seasmean $Result_path/$Autumn
ncra -F -d time,4,200,4 $Result_path/$Seasmean $Result_path/$Winter
ncra -F -d time,5,200,4 $Result_path/$Seasmean $Result_path/$Spring
