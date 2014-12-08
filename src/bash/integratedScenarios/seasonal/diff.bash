#!/bin/bash
#calculate the differences of seasonal mean between rcp45,rcp85 and historical.

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*
#$ -m be
#$ -M 350096758@qq.com

seasons="SON DJF MAM JJA"
scenarios="rcp45"
variables="PREC"
dir=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/diff/seasonal/
for var in $variables
do
	for season in $seasons
	do
		for scenario in $scenarios
		do
			dir_hist=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/historical/seasonal/$var/seasons${season}.nc4
			dir_scenario=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/$var/seasons${season}.nc4
			dir_diff=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/diff/seasonal/${scenario}_${var}_seasons${season}.nc4
			if [ ! -d $dir]
			then
				mkdir -p $dir
			fi
			cdo sub $dir_scenario $dir_hist $dir_diff 
		done
	done
done


