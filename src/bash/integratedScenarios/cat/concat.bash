#!/bin/bash
#concatenate the monthly files from Stumbaugh directory

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*

scenarios="historical rcp45 rcp85"
variables="SWE PREC EVAP RUNOFF BASEFLOW SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3"
#variables="PREC EVAP RUNOFF BASEFLOW"
#variables="TMAX TMIN"

for scenario in $scenarios
do
	for var in $variables
	do
		inpath=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/CCSM4/wus_full.1/ncLL/$var
		infile=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/CCSM4/wus_full.1/ncLL/$var/*mean
		outpath=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cat/$var
		if [ ! -d $outpath ]
		then
			mkdir -p $outpath
		fi
		
		if [ -d $outpath/concat.nc ]
		then
			exit
		fi

		if [ -d $inpath ]
		then
			#ifile=$inpath/????-??-??_????-??-??_mean
		#	ifile=$inpath/*mean
			cdo cat $infile $outpath/concat.nc
#			ncrcat -O $ifile $outpath/concat.nc
		fi

	done
done
