#!/bin/bash
#calculate seasonal mean of variables

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

scenarios="$1" ### scenarios="historical rcp45 rcp85"
variables="$2" ### variables='SWE EVAP SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 BASEFLOW PREC RUNOFF'
models="$3" ### CCSM4 MIROC5

for scenario in $scenarios
do
	for var in $variables
	do
		inpath=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/cat/$var/concat.nc
		outpath=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/$var
		if [ ! -d $outpath ]
		then
			mkdir -p $outpath
		fi
		if [ -f $inpath ];then
			if [ ! -f $outpath/seasmean.nc ];then
				cdo yseasmean $inpath $outpath/seasmean.nc
				cdo splitseas $outpath/seasmean.nc $outpath/seasons
			fi
		fi
	done
done

for scenario in $scenarios
do
	dir_SL1=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/SOIL_MOIST1/seasmean.nc
	dir_SL2=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/SOIL_MOIST2/seasmean.nc
	dir_SL3=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/SOIL_MOIST3/seasmean.nc
	dir_SL=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/SOIL_MOIST
	if [ ! -d $dir_SL ]
	then
		mkdir -p $dir_SL
	fi
	if [ -f $dir_SL1 ] && [ -f $dir_SL2 ] && [ -f $dir_SL3 ];then
		if [ ! -f $dir_SL/seasmean.nc ];then
			cdo merge $dir_SL1 $dir_SL2 $dir_SL3 $dir_SL/seasmean_tmp.nc
			cdo expr,"Soil_moisture=Soil_moisture1+Soil_moisture2+Soil_moisture3" $dir_SL/seasmean_tmp.nc $dir_SL/seasmean.nc
			cdo splitseas $dir_SL/seasmean.nc $dir_SL/seasons
			rm $dir_SL/seasmean_tmp.nc
		fi
	fi
done

for scenario in $scenarios
do
	dir_runoff=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/RUNOFF/seasmean.nc
	dir_baseflow=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/BASEFLOW/seasmean.nc
	dir_flow=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/seasonal/FLOW
	if [ ! -d $dir_flow ]
	then
		mkdir -p $dir_flow
	fi
	if [ -f $dir_runoff ] && [ -f $dir_baseflow];then
		if [ ! -f $dir_flow/seasmean.nc ];then
			cdo merge $dir_runoff $dir_baseflow $dir_flow/seasmean_tmp.nc
			cdo expr,"Flow=Runoff+Baseflow" $dir_flow/seasmean_tmp.nc $dir_flow/seasmean.nc
			cdo splitseas $dir_flow/seasmean.nc $dir_flow/seasons
			rm $dir_flow/seasmean_tmp.nc
		fi
	fi
done
