#!/bin/bash
#Calculate the differences between forcings of different scenarios

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*

variables='PREC TMAX TMIN'
seasons='SON DJF MAM JJA'
scenarios='rcp45'

for scenario in $scenarios
do
	for var in $variables
	do
		for season in $seasons
		do
			dir_rcp=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/forcing/$var/seasons$season.nc4
			dir_hist=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/historical/seasonal/forcing/$var/seasons$season.nc4
			dir_diff=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/forcing/diff/$var
			if [ ! -d $dir_diff ]
			then
				mkdir -p $dir_diff
			fi
			cdo sub $dir_rcp $dir_hist $dir_diff/seasons$season.nc4
		done
	done
done
