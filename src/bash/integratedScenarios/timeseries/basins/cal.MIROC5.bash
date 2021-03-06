#!/bin/bash
#Western U.S. is divided into four parts. The field mean is calculated for each part. 
#discharge is calculated by adding runoff and baseflow
#directory of data: 

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

scenarios="historical rcp45 rcp85"
#scenarios="historical rcp45 rcp85"
variables="PREC EVAP RUNOFF BASEFLOW SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 SWE"
#variables="PREC"
basins="Dalles"


for scenario in $scenarios
do
	for basin in $basins
	do
		for var in $variables
		do
			inpath=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/$var.monmean.calclim.nc
			outpath=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/fldmean_month_series_$var
			if [ -f $inpath ];then
				if [ ! -d `dirname $outpath` ]
				then
					mkdir -p `dirname $outpath`
				fi
			

				if [ ! -f $outpath ];then
					cdo fldmean $inpath $outpath
				fi
			fi
		done
	done
done

for scenario in $scenarios
do
	for basin in $basins
	do
		dir_runoff=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/RUNOFF.monmean.calclim.nc	
		dir_baseflow=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/BASEFLOW.monmean.calclim.nc
		dir_flow=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/FLOW.monmean.calclim.nc
		if [ -f $dir_runoff ] && [ -f $dir_baseflow];then
			if [ ! -d `dirname $dir_flow` ]
			then
				mkdir -p $dir_flow
			fi
		
			if [ ! -f $dir_flow ];then
				cdo merge $dir_runoff $dir_baseflow $dir_flow.tmp
				cdo expr,"Flow=Runoff+Baseflow" $dir_flow.tmp $dir_flow
				rm $dir_flow.tmp
			fi
		fi
	done
done

for scenario in $scenarios
do
	for basin in $basins
	do
		dir_SL1=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/SOIL_MOIST1.monmean.calclim.nc
		dir_SL2=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/SOIL_MOIST2.monmean.calclim.nc
		dir_SL3=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/SOIL_MOIST3.monmean.calclim.nc
		dir_SL=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/$scenario/timeseries/basins/Dalles/cal/SOIL_MOIST.monmean.calclim.nc
		if [ -f $dir_SL1 ] && [ -f $dir_SL2 ] && [ -f $dir_SL3];then
			rm $dir_SL
			if [ ! -f $dir_SL ];then
				cdo merge $dir_SL1 $dir_SL2 $dir_SL3 $dir_SL.tmp
				cdo expr,"Soil_moisture=Soil_moisture1+Soil_moisture2+Soil_moisture3" $dir_SL.tmp $dir_SL
				rm $dir_SL.tmp
			fi
		fi
	done
done

exit

	
for basin in $basins
do
        for var in $variables
        do
                file_historical=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/historical/timeseries/division/forcing/$var/month_series_$pos
                file_rcp45=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/rcp45/timeseries/division/forcing/$var/month_series_$pos
                file_cat=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/rcp45/timeseries/division/forcing/$var/month_series_cat_$pos
                file_diff=/raid3/jiawei/integrated_scenarios/MIROC5/simulator/rcp45/timeseries/division/forcing/$var/fldmean_month_series_rcp45_cat_$pos
                if [ ! -f $file_diff ];then
                        cdo fldmean $file_cat $file_diff
                fi
        done
done

