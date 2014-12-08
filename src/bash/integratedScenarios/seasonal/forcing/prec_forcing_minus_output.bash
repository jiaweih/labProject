#/bin/bash
Calculate the difference between forcing of precipitation and output of precipitation.

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*

scenarios='historical'
seasons='SON DJF MAM JJA'

for scenario in $scenarios
do
	for season in $seasons
	do
		dir_forcing=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/forcing/PREC/seasons$season.nc4
		dir_output=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/PREC/seasons$season.nc4
		dir_diff=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/seasonal/diff/PREC
		if [ ! -d $dir_diff ]
		then
			mkdir -p $dir_diff
		fi
		cdo sub $dir_forcing $dir_output $dir_diff/seasons$season.nc4
	done
done
