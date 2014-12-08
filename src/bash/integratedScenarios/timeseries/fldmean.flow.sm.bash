#!/bin/bash
#Western U.S. is divided into four parts. The field mean is calculated for each part. 
#discharge is calculated by adding runoff and baseflow
#directory of data: 

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

scenarios="$1" #scenarios="historical rcp45 rcp85"
variables="PREC EVAP RUNOFF BASEFLOW SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 SWE"
models="$2"
positions="PNW Interior California SW"

for scenario in $scenarios
do
	dir_runoff=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/RUNOFF
	dir_baseflow=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/BASEFLOW
	dir_flow=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/FLOW
	if [ ! -d $dir_flow ]
	then
		mkdir -p $dir_flow
	fi

	for pos in $positions
	do
		if [ -f $dir_runoff/fldmean_month_series_$pos ] && [ -f $dir_baseflow/fldmean_month_series_$pos ];then
			if [ ! -f $dir_flow/fldmean_month_series_$pos ];then
				cdo merge $dir_runoff/fldmean_month_series_$pos $dir_baseflow/fldmean_month_series_$pos $dir_flow/fldmean_month_series_tmp_$pos
				cdo expr,"Flow=Runoff+Baseflow" $dir_flow/fldmean_month_series_tmp_$pos $dir_flow/fldmean_month_series_$pos
				rm $dir_flow/fldmean_month_series_tmp_$pos
			fi
		fi
	done
done

for scenario in $scenarios
do 	
	for pos in $positions
	do
		dir_SL1=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/SOIL_MOIST1/fldmean_month_series_$pos
		dir_SL2=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/SOIL_MOIST2/fldmean_month_series_$pos
		dir_SL3=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/SOIL_MOIST3/fldmean_month_series_$pos
		dir_SL=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/SOIL_MOIST
		if [ ! -d $dir_SL ];then
			mkdir -p $dir_SL
		fi

		if [ -f $dir_SL1 ] && [ -f $dir_SL2 ] && [ -f $dir_SL3 ];then
			if [ ! -f $dir_SL/fldmean_month_series_$pos ];then
				cdo merge $dir_SL1 $dir_SL2 $dir_SL3 $dir_SL/tmp
				cdo expr,"Soil_moisture=Soil_moisture1+Soil_moisture2+Soil_moisture3" $dir_SL/tmp $dir_SL/fldmean_month_series_$pos
				rm $dir_SL/tmp
			fi
		fi
	done
done
	

