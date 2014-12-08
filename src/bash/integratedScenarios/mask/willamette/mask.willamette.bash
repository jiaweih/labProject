#!/bin/bash
##This script will create a mask dataset based on mask file of Columbia Basin in Dalle.

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-6

scenarios="historical"
variables="BASEFLOW PREC EVAP RUNOFF"
basins="willp"
for scenario in $scenarios
do
	for var in $variables
	do
		for basin in $basins
		do
			ifile=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/CCSM4/wus_full.1/ncLL.summ/$var.monmean.nc
			ofile=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/timeseries/basins/$basin/$var.monmean.nc
			if [ ! -d `dirname $ofile` ];then
				mkdir -p $ofile	
			fi
		
			if [ ! -f $ofile ];then
				cdo remapcon,mask $ifile mask.nc
				cdo mul mask.nc willp.nc $ofile
				rm mask.nc
			fi
		done
	done
done
