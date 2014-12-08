#!/bin/bash

#This script aims to compare SWM dataset with Livneh dataset; SWM lasts from 1915 to 2011 with 1/2 degree, Livneh lasts from 1915 to 2011 with 1/8 degree;
#The scrips does the following things: 1. convert the grid of Liveh to that of SWM  2. calculate the anomalies of three variables  3. divide the datasets of differences into two parts: pre1950 and pos1950  4. arrange the resulting datasets according to seasons

inpath1=/raid2/homefc/conus/data.sets/SWM/corrected
inpath2=/raid3/jiawei/homero/data/swm/L14
inpath3=/raid2/homefc/conus/data.sets/L14
outpath=/raid3/jiawei/homero/data/swm/L14

livneh_1915_2011=`printf "data.191501_201112.nc"`
swm_1915_2011=`printf "swm.191501_201112.nc"`
swm_m_livneh_14=`printf "swm.diff.nc"`
pre_diff=`printf "swm.pre1950.diff.nc"`
pos_diff=`printf "swm.pos1950.diff.nc"`
pre_seasmn=`printf "swm.pre1950.seasmean.nc"`
pos_seasmn=`printf "swm.pos1950.seasmean.nc"`
pre_Spng=`printf "swm.pre1950.Spring.nc"`
pre_Sumn=`printf "swm.pre1950.Summer.nc"`
pre_Autn=`printf "swm.pre1950.Autumn.nc"`
pre_Wntr=`printf "swm.pre1950.Winter.nc"`
pos_Spng=`printf "swm.pos1950.Spring.nc"`
pos_Sumn=`printf "swm.pos1950.Summer.nc"`
pos_Autn=`printf "swm.pos1950.Autumn.nc"`
pos_Wntr=`printf "swm.pos1950.Winter.nc"`
livneh_remap=`printf "livneh.remapSWM.nc"`


#transform the grids of Livneh dataset to the grids of SWM dataset
cdo remapcon,$inpath1/$swm_1915_2011 $inpath3/$livneh_1915_2011 $inpath2/$livneh_remap

#calculate the differences between Livneh dataset and SWM dataset
ncbo -v Prec,Tmax,Tmin $inpath1/$swm_1915_2011 $inpath2/$livneh_remap $outpath/$swm_m_livneh_14

#split the dataset of the difference into pre1950 and pos1950
ncea -F -d time,1,432 $inpath2/$swm_m_livneh_14 $outpath/$pre_diff
ncea -F -d time,433,1164 $inpath2/$swm_m_livneh_14 $outpath/$pos_diff

#calculate the seasonal mean value of variables 
cdo seasmean $inpath2/$pre_diff $outpath/$pre_seasmn
cdo seasmean $inpath2/$pos_diff $outpath/$pos_seasmn

#put dataset of same season together in one dataset
ncra -F -d time,2,144,4 $inpath2/$pre_seasmn $outpath/$pre_Sumn
ncra -F -d time,3,144,4 $inpath2/$pre_seasmn $outpath/$pre_Autn
ncra -F -d time,4,144,4 $inpath2/$pre_seasmn $outpath/$pre_Wntr
ncra -F -d time,5,144,4 $inpath2/$pre_seasmn $outpath/$pre_Spng

ncra -F -d time,2,144,4 $inpath2/$pos_seasmn $outpath/$pos_Sumn
ncra -F -d time,3,144,4 $inpath2/$pos_seasmn $outpath/$pos_Autn
ncra -F -d time,4,144,4 $inpath2/$pos_seasmn $outpath/$pos_Wntr
ncra -F -d time,5,144,4 $inpath2/$pos_seasmn $outpath/$pos_Spng


