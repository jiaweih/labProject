#/bin/bash

#This script aims to compare CRU dataset and Livneh dataset;CRU dataset has been standardized for comparison with Livneh in another script, so these two datasets now have the same period of time, same units, same variable names, except grid resolution, with CRU of 1/2 degrees, Livneh of 1/8 degrees.
#This script carrys out the following procedures:1. transform the grids of Livneh's to CRUS's  2. calculate the differences of three variables, CRU minus Livneh  3. divide the datasets of anomaly into two parts: pre1950 and pos 1950  4. arrange the datasets according to seasons

inpath=/raid3/jiawei/homero/data/cru/L14
inpath2=/raid2/homefc/conus/data.sets/L14
outpath=/raid3/jiawei/homero/data/cru/L14
livneh_o=`printf "data.191501_201112.nc"`
cru_1915_2011=`printf "cru.1915.2011.nc"`
cru_m_livneh=`printf "cru.diff.nc"`
pre_diff=`printf "cru.pre1950.diff.nc"`
pos_diff=`printf "cru.pos1950.diff.nc"`
pre_seasmn=`printf "cru.pre1950.seasmean.nc"`
pos_seasmn=`printf "cru.pos1950.seasmean.nc"`
pre_Spng=`printf "cru.pre1950.Spring.nc"`
pre_Sumn=`printf "cru.pre1950.Summer.nc"`
pre_Autn=`printf "cru.pre1950.Autumn.nc"`
cru_pre_Wntr=`printf "cru.pre1950.Winter.nc"`
pos_Spng=`printf "cru.pos1950.Spring.nc"`
pos_Sumn=`printf "cru.pos1950.Summer.nc"`
pos_Autn=`printf "cru.pos1950.Autumn.nc"`
pos_Wntr=`printf "cru.pos1950.Winter.nc"`
livneh_remap=`printf "livneh.remapCRU.nc"`

#transform the grids of Livneh dataset to the grids of CRU dataset
cdo remapcon,$inpath/$cru_1915_2011 $inpath2/$livneh_o $outpath/$livneh_remap

#calculate the differences between Livneh dataset and CRU dataset
ncbo -v Prec,Tmax,Tmin $inpath/$cru_1915_2011 $outpath/$livneh_remap $outpath/$cru_m_livneh

#split the dataset of the difference into pre1950 and pos1950,432 means the period of Dec, 1949
ncea -F -d time,1,432 $inpath/$cru_m_livneh $outpath/$pre_diff
ncea -F -d time,433,1164 $inpath/$cru_m_livneh $outpath/$pos_diff

#calculate the seasonal mean value of variables 
cdo seasmean $inpath/$pre_diff $outpath/$pre_seasmn
cdo seasmean $inpath/$pos_diff $outpath/$pos_seasmn

#put dataset of same season together in one dataset,2 for summer, 3 for autumn, 4 for winter, 5 for spring
ncra -F -d time,2,144,4 $inpath/$pre_seasmn $outpath/$pre_Sumn
ncra -F -d time,3,144,4 $inpath/$pre_seasmn $outpath/$pre_Autn
ncra -F -d time,4,144,4 $inpath/$pre_seasmn $outpath/$cru_pre_Wntr
ncra -F -d time,5,144,4 $inpath/$pre_seasmn $outpath/$pre_Spng

ncra -F -d time,2,144,4 $inpath/$pos_seasmn $outpath/$pos_Sumn
ncra -F -d time,3,144,4 $inpath/$pos_seasmn $outpath/$pos_Autn
ncra -F -d time,4,144,4 $inpath/$pos_seasmn $outpath/$pos_Wntr
ncra -F -d time,5,144,4 $inpath/$pos_seasmn $outpath/$pos_Spng

