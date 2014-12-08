#!/bin/bash
#
#This script estimates the temporal mean of the netCDFs of VIC
#runs... what does the mean amount of mm means? In those cases
# I need to multiply by the number of days in a year to get MAP.
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#
echo "Started " &> logfile_histmeans
date &>> logfile_histmeans

mkdir means

FILES=hist.sh.*

#update format
for file in $FILES
do
    ncks -O -x -v timestp,nav_lon,nav_lat,land,CellID $file junk.nc
    ncrename -d tstep,time junk.nc
    cdo setgrid,cbgrid.txt junk.nc $file
    rm junk.nc
done





for file in $FILES
do
    ncra -F -d tstep,1,,1 $file means/$file &> error #mean for the time average
    ncks -4 -L 5 $file temp.nc #compressing
    mv temp.nc $file
done

echo "Completed " &>> logfile_histmeans
date &>> logfile_histmeans
