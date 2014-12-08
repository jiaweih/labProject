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
	for var in $variables
	do
		inpath=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/$models/wus_full.1/ncLL.summ/$var.monmean.nc
		outpath=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/$var
		if [ ! -d $outpath ]
		then
			mkdir -p $outpath
		fi
		if [ -f $inpath ];then
			if [ ! -f $outpath/month_series_PNW ];then
				cdo sellonlatbox,-124.594,-116,42,52.8438 $inpath $outpath/month_series_PNW
				cdo sellonlatbox,-116,-103.031,42,52.8438 $inpath $outpath/month_series_Interior
				cdo sellonlatbox,-124,-116,29.0312,42 $inpath $outpath/month_series_California
				cdo sellonlatbox,-116,-103.031,29.0312,42 $inpath $outpath/month_series_SW
				for pos in $positions
				do
					cdo fldmean $outpath/month_series_$pos $outpath/fldmean_month_series_$pos
				done
			fi
		fi
	done
done


