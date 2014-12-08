#!/bin/bash
#Western U.S. is divided into four parts. The field mean is calculated for each part. 

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-2-*

scenarios="$1" ### scenarios="historical rcp45 rcp85"
variables="$2" ### variables="PREC TMAX TMIN"
models="$3"   ### CCSM4 MIROC5
positions="PNW Interior California SW"


for scenario in $scenarios
do
	for var in $variables
	do
		inpath=/raid3/stumbaugh/IS/CONUS/v2.2/vicfrcnc/$scenario/$models/ncLL.summ/$var.monmean.nc
		outpath=/raid3/jiawei/integrated_scenarios/$models/simulator/$scenario/timeseries/division/forcing/$var
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


for var in $variables
do
	for pos in $positions
	do
		file_historical=/raid3/jiawei/integrated_scenarios/$models/simulator/historical/timeseries/division/forcing/$var/month_series_$pos
		file_rcp45=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/forcing/$var/month_series_$pos
		file_cat=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/forcing/$var/month_series_cat_$pos
		file_diff=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp45/timeseries/division/forcing/$var/fldmean_month_series_rcp45_hist_cat_$pos
		if [ -f $file_historical ] && [ -f $file_rcp45 ];then
			if [ ! -f $file_cat ];then
				cdo cat $file_historical $file_rcp45 $file_cat
			fi

			if [ ! -f $file_diff ];then
				cdo fldmean $file_cat $file_diff
			fi
		fi
	done
done

for var in $variables
do
        for pos in $positions
        do
                file_historical=/raid3/jiawei/integrated_scenarios/$models/simulator/historical/timeseries/division/forcing/$var/month_series_$pos
                file_rcp85=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/forcing/$var/month_series_$pos
                file_cat=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/forcing/$var/month_series_cat_$pos
                file_diff=/raid3/jiawei/integrated_scenarios/$models/simulator/rcp85/timeseries/division/forcing/$var/fldmean_month_series_rcp85_hist_cat_$pos
                if [ -f $file_historical ] && [ -f $file_rcp85 ];then
                        if [ ! -f $file_cat ];then
                                cdo cat $file_historical $file_rcp85 $file_cat
                        fi

                        if [ ! -f $file_diff ];then
                                cdo fldmean $file_cat $file_diff
                        fi
                fi
        done
done
