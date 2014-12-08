#!/bin/bash
##This script will create a mask dataset based on mask file of Columbia Basin in Dalle.

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

#scenarios="historical rcp45 rcp85"
scenarios="$1"
#variables="BASEFLOW PREC EVAP FLOW RUNOFF SWE SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 SOIL_MOIST"
variables="$2"
basins="Dalles"
for scenario in $scenarios
do
	for var in $variables
	do
		for basin in $basins
		do
			ifile=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/$var.monmean.calclim.nc
			ofile=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/timeseries/basins/Dalles/cal/$var.monmean.calclim.nc
			if [ ! -d `dirname $ofile` ];then
				mkdir -p `dirname $ofile`	
			fi
		
			if [ -f $ifile ];then
				if [ ! -f $ofile ];then
					#cdo remapcon,mask $ifile mask.nc ### bug to be fixed
					#cdo mul mask.nc dalle.nc $ofile
					cdo ifthen mask.nc $ifile $ofile
					echo $var
					#rm mask.nc
				fi
			fi
		done
	done
done

