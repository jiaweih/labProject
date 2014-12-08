#!/bin/bash

inpath1=/raid2/homefc/conus/data.sets/Livneh_PRISM
inpath2=/raid2/homefc/conus/data.sets/L14
outpath=/raid3/jiawei/homero/data/livneh/L13.m.L14

l_o=`printf "data.191501_201112.nc"` #file name for two datasets to be compared (two datasets are created by Livneh at different time, have the same file name)
l13_m_l14=`printf "livneh.diff.nc"`       #differences between two datasets

#before 1950 and after 1950 for datasets of differences
pre_1950_diff=`printf "livneh.pre1950.diff.nc"`
pos_1950_diff=`printf "livneh.pos1950.diff.nc"`

#datasets for seasonal mean value
pre_1950_diff_sea=`printf "livneh.pre1950.seasmean.diff.nc"`
pos_1950_diff_sea=`printf "livneh.pos1950.seasmean.diff.nc"`

#mean value for each season before 1950
pre_Spng=`printf "livneh.pre1950.Spring.nc"`
pre_Smmr=`printf "livneh.pre1950.Summer.nc"`
pre_Atmn=`printf "livneh.pre1950.Autumn.nc"`
pre_Wntr=`printf "livneh.pre1950.Winter.nc"`

#mean value for each season after 1950
pos_Spng=`printf "livneh.pos1950.Spring.nc"`
pos_Smmr=`printf "livneh.pos1950.Summer.nc"`
pos_Atmn=`printf "livneh.pos1950.Autumn.nc"`
pos_Wntr=`printf "livneh.pos1950.Winter.nc"`


#calculate the differences between Livneh datasets
ncbo -v Prec,Tmax,Tmin $inpath1/$l_o $inpath2/$l_o $outpath/$l13_m_l14

#split the dataset of the difference into pre1950 and pos1950
ncea -F -d time,1,432 $outpath/$l13_m_l14 $outpath/$pre_1950_diff
ncea -F -d time,433,1164 $outpath/$l13_m_l14 $outpath/$pos_1950_diff

#calculate the seasonal mean value of variables 
cdo seasmean $outpath/$pre_1950_diff $outpath/$pre_1950_diff_sea
cdo seasmean $outpath/$pos_1950_diff $outpath/$pos_1950_diff_sea


#put dataset of same season together in one dataset
ncra -F -d time,2,144,4 $outpath/$pre_1950_diff_sea $outpath/$pre_Smmr
ncra -F -d time,3,144,4 $outpath/$pre_1950_diff_sea $outpath/$pre_Atmn
ncra -F -d time,4,144,4 $outpath/$pre_1950_diff_sea $outpath/$pre_Wntr
ncra -F -d time,5,144,4 $outpath/$pre_1950_diff_sea $outpath/$pre_Spng

ncra -F -d time,2,144,4 $outpath/$pos_1950_diff_sea $outpath/$pos_Smmr
ncra -F -d time,3,144,4 $outpath/$pos_1950_diff_sea $outpath/$pos_Atmn
ncra -F -d time,4,144,4 $outpath/$pos_1950_diff_sea $outpath/$pos_Wntr
ncra -F -d time,5,144,4 $outpath/$pos_1950_diff_sea $outpath/$pos_Spng


