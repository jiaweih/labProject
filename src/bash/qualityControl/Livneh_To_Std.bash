#!/bin/bash -x

cwd=`pwd`
inpath=/home/raid9/homefc/conus/data.sets/Livneh_noPRISM
outpath=/raid3/jiawei/homero/data/livneh
#str="??"
for year in {1915..2011}
do
		fin=`printf "data.%04d??.nc" $year`
		fout=`printf "data.%04d.nc" $year`
		echo $fin
		echo $fout
		ncrcat $inpath/$fin  $outpath/$fout
done

ncrcat $outpath/data.????.nc $outpath/data.nc
