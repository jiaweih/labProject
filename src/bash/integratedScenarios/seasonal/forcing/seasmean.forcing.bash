#!/bin/bash
#calculate seasonal mean of variables

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*

#variables='SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3'
#variables='SWE EVAP SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 BASEFLOW PREC RUNOFF'
#variables='PREC TMAX'
variables='TMIN'
#variables='SWE SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3'
#scenarios="historical rcp45 rcp85"
scenarios="historical rcp45"

for scenario in $scenarios
do
	for var in $variables
	do
#		inpath=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cat/$var/concat.nc
		inpath=/raid3/stumbaugh/IS/CONUS/v2.2/vicfrcnc/$scenario/CCSM4/ncLL.summ/$var.monmean.nc
#		outpath=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/$var
		outpath=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/forcing/$var
		if [ ! -d $outpath ]
		then
			mkdir -p $outpath
		fi
		cdo yseasmean $inpath $outpath/seasmean.nc
		cdo splitseas $outpath/seasmean.nc $outpath/seasons
	done
done

exit
for scenario in $scenarios
do
	dir_SL1=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/SOIL_MOIST1/seasmean.nc
	dir_SL2=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/SOIL_MOIST2/seasmean.nc
	dir_SL3=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/SOIL_MOIST3/seasmean.nc
	dir_SL=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/SOIL_MOIST
	if [ ! -d $dir_SL ]
	then
		mkdir -p $dir_SL
	fi
	cdo merge $dir_SL1 $dir_SL2 $dir_SL3 $dir_SL/seasmean_tmp.nc
	cdo expr,"Soil_moisture=Soil_moisture1+Soil_moisture2+Soil_moisture3" $dir_SL/seasmean_tmp.nc $dir_SL/seasmean.nc
	cdo splitseas $dir_SL/seasmean.nc $dir_SL/seasons
	rm $dir_SL/seasmean_tmp.nc
done

for scenario in $scenarios
do
	dir_runoff=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/RUNOFF/seasmean.nc
	dir_baseflow=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/BASEFLOW/seasmean.nc
	dir_flow=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/FLOW
	if [ ! -d $dir_flow ]
	then
		mkdir -p $dir_flow
	fi
	cdo merge $dir_runoff $dir_baseflow $dir_flow/seasmean_tmp.nc
	cdo expr,"Flow=Runoff+Baseflow" $dir_flow/seasmean_tmp.nc $dir_flow/seasmean.nc
	cdo splitseas $dir_flow/seasmean.nc $dir_flow/seasons
	rm $dir_flow/seasmean_tmp.nc
done
