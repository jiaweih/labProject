#/bin/bash
###Calculate the mean SWE of April 1

#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -q default.q@compute-0-*

scenarios='historical rcp45 rcp85'

for scenario in $scenarios
do
	indir=/raid3/stumbaugh/IS/CONUS/v2.2/simulator/$scenario/CCSM4/wus_full.1/ncLL/SWE
	outdir=/raid3/jiawei/integrated_scenarios/CCSM4/simulator/$scenario/SWE
	if [ ! -d $outdir ]
	then
		mkdir -p $outdir
	fi

	if [ -e $outdir/04_01_day1 ]
	then
		exit
	fi

	if [ -d $indir ]
	then
		for year in {1950..2005}
	        do
               		ncks --mk_rec_dmn Time $indir/$year-04-01_${year}-04-30_day1 $outdir/$year-04-01_${year}-04-30_day1
       		done
		ncrcat -O -v SWE $outdir/????-04-01_????-04-30_day1 $outdir/04-01_04-30_day1
		cdo timmean $outdir/04-01_04-30_day1 $outdir/04_01_day1
		rm $outdir/04-01_04-30_day1
		rm $outdir/????-04-01_????-04-30_day1
	fi
done
