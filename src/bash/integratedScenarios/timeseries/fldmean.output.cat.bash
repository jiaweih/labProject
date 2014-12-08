#!/bin/bash
#Western U.S. is divided into four parts. The field mean is calculated for each part. 
#discharge is calculated by adding runoff and baseflow
#directory of data: 

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

variables="PREC EVAP RUNOFF BASEFLOW FLOW SOIL_MOIST1 SOIL_MOIST2 SOIL_MOIST3 SOIL_MOIST SWE"
models="$1"
positions="PNW Interior California SW"




for var in $variables
do
	for pos in $positions
	do
		file_historical=/raid3/jiawei/integrated_scenarios/$models/simulator/historical/timeseries/division/$var/month_series_$pos
		file_rcp45=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/$var/month_series_$pos
		file_cat=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/$var/month_series_rcp45_hist_cat_$pos
		file_cat_fldmean=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/$var/fldmean_month_series_rcp45_hist_cat_$pos
		if [ -f $file_historical ] && [ -f $file_rcp45 ];then
			rm $file_cat
			if [ ! -f $file_cat ];then
				cdo cat $file_historical $file_rcp45 $file_cat
				cdo fldmean $file_cat $file_cat_fldmean
			fi
		fi
	done
done

for var in $variables
do
        for pos in $positions
        do
                file_historical=/raid3/jiawei/integrated_scenarios/$models/simulator/historical/timeseries/division/$var/month_series_$pos
                file_rcp85=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/$var/month_series_$pos
                file_cat=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/$var/month_series_rcp85_hist_cat_$pos
		file_cat_fldmean=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/$var/fldmean_month_series_rcp85_hist_cat_$pos
                if [ -f $file_historical ] && [ -f $file_rcp85 ];then
			rm $file_cat
                        if [ ! -f $file_cat ];then
                                cdo cat $file_historical $file_rcp85 $file_cat
                                cdo fldmean $file_cat $file_cat_fldmean
                        fi
                fi
        done
done


