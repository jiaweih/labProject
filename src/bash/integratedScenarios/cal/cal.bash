#/bin/bash

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-6

scenarios='historical rcp45 rcp85'
variables='BASEFLOW PREC EVAP RUNOFF SWE SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3'

for scenario in $scenarios
do
	for var in $variables
	do
		ifile=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/CCSM4/wus_full.1/ncLL.summ/$var.monmean.calclim.nc
		ofile=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/$var.monmean.calclim.nc
		if [ ! -d `dirname $ofile` ];then
			mkdir -p `dirname $ofile`
		fi
		
		if [ -f $ifile ];then
			if [ ! -f $ofile ];then
				cp $ifile `dirname $ofile`
			fi
		fi
	done
done

for scenario in $scenarios
do
	file_runoff=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/RUNOFF.monmean.calclim.nc
	file_baseflow=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/BASEFLOW.monmean.calclim.nc
	file_flow=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/FLOW.monmean.calclim.nc
	if [ -f $file_runoff ];then
		if [ ! -f $file_flow ];then
			cdo merge $file_runoff $file_baseflow $file_flow.tmp
			cdo expr,'Flow=Runoff+Baseflow' $file_flow.tmp $file_flow
			rm $file_flow.tmp
		fi
	fi
done

for scenario in $scenarios
do
	file_SL1=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/SOIL_MOIST1.monmean.calclim.nc
	file_SL2=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/SOIL_MOIST2.monmean.calclim.nc
	file_SL3=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/SOIL_MOIST3.monmean.calclim.nc
	file_SL=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/cal/SOIL_MOIST.monmean.calclim.nc
	if [ -f $file_SL1 ];then
		if [ ! -f $file_SL ];then
			cdo merge $file_SL1 $file_SL2 $file_SL3 $file_SL.tmp
			cdo expr,'Soil_moisture=Soil_moisture1+Soil_moisture2+Soil_moisture3' $file_SL.tmp $file_SL
			rm $file_SL.tmp
		fi
	fi
done
