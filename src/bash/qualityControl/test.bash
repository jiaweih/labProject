#!/usr/bin/python

#combine Livneh monthly data into yearly data and remap Livneh data to dataset with the same grid as CRU dataset 
for year in {1915..2011}
do
    
	ncrcat /home/raid9/homefc/conus/data.sets/Livneh_noPRISM/data.$year??.nc /raid3/jiawei/homero/data/livneh/data.$year.nc
    	cdo remapcon,/home/raid9/homefc/conus/data.sets/CRU/clip/mask/cru_ts3.21.1901.2012.pre.mask.nc /raid3/jiawei/homero/data/livneh/data.$year.nc /raid3/jiawei/homero/data/cru/remap/data.$year.nc

done

#combine remapped dataset into one single dataset
ncrcat /raid3/jiawei/homero/data/cru/remap/data.????.nc /raid3/jiawei/homero/data/cru/remap/data.nc

#copy CRU dataset
cp /home/raid9/homefc/conus/data.sets/CRU/clip/mask/cru_ts3.21.1901.2012.pre.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.pre.mask.nc
cp /home/raid9/homefc/conus/data.sets/CRU/clip/mask/cru_ts3.21.1901.2012.tmx.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmx.mask.nc 
cp /home/raid9/homefc/conus/data.sets/CRU/clip/mask/cru_ts3.21.1901.2012.tmn.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmn.mask.nc    

#change the variable name of CRU dataset
ncrename -v pre,Prec /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.pre.mask.nc
ncrename -v tmx,Tmax /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmx.mask.nc
ncrename -v tmn,Tmin /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmn.mask.nc

#extract part of CRU dataset to match the time of remapped Livneh dataset
ncea -F -d time,169,1332 /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.pre.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Prec.mask.nc
ncea -F -d time,169,1332 /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmx.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Tmax.mask.nc
ncea -F -d time,169,1332 /raid3/jiawei/homero/data/cru/cru_ts3.21.1901.2012.tmn.mask.nc /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Tmin.mask.nc

#calculate daily Precipitation in CRU data, and change the filename of Tmax, Tmin dataset to be consistent with filename of Precipitation 
ncap2 -s Prec=Prec/30.0 /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Prec.mask.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Prec.nc
mv /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Tmax.mask.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Tmax.nc
mv /raid3/jiawei/homero/data/cru/cru_ts3.21.1915.2011.Tmin.mask.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Tmin.nc

#calculate the difference between Livneh dataset and CRU dataset
ncbo -v Prec /raid3/jiawei/homero/data/cru/remap/data.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Prec.nc /raid3/jiawei/homero/data/cru/Prec.diff.nc
ncbo -v Tmax /raid3/jiawei/homero/data/cru/remap/data.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Tmax.nc /raid3/jiawei/homero/data/cru/Tmax.diff.nc
ncbo -v Tmin /raid3/jiawei/homero/data/cru/remap/data.nc /raid3/jiawei/homero/data/cru/cru.1915.2011.Tmin.nc /raid3/jiawei/homero/data/cru/Tmin.diff.nc

#split the anomaly dataset into two parts, pre1950 and pos1950
ncea -F -d time,1,432 /raid3/jiawei/homero/data/cru/Prec.diff.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.diff.nc
ncea -F -d time,1,432 /raid3/jiawei/homero/data/cru/Tmax.diff.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.diff.nc
ncea -F -d time,1,432 /raid3/jiawei/homero/data/cru/Tmin.diff.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.diff.nc

ncea -F -d time,433,1164 /raid3/jiawei/homero/data/cru/Prec.diff.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.diff.nc
ncea -F -d time,433,1164 /raid3/jiawei/homero/data/cru/Tmax.diff.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.diff.nc
ncea -F -d time,433,1164 /raid3/jiawei/homero/data/cru/Tmin.diff.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.diff.nc

#calculate seasonal mean of anomaly dataset
cdo seasmean /raid3/jiawei/homero/data/cru/Prec.pre1950.diff.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.seasmean.nc
cdo seasmean /raid3/jiawei/homero/data/cru/Tmax.pre1950.diff.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.seasmean.nc
cdo seasmean /raid3/jiawei/homero/data/cru/Tmin.pre1950.diff.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.seasmean.nc

cdo seasmean /raid3/jiawei/homero/data/cru/Prec.pos1950.diff.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.seasmean.nc
cdo seasmean /raid3/jiawei/homero/data/cru/Tmax.pos1950.diff.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.seasmean.nc
cdo seasmean /raid3/jiawei/homero/data/cru/Tmin.pos1950.diff.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.seasmean.nc

#create dataset of anomaly data for each season
ncra -F -d time,5,144,4 /raid3/jiawei/homero/data/cru/Prec.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.Spring.nc
ncra -F -d time,2,144,4 /raid3/jiawei/homero/data/cru/Prec.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.Summer.nc
ncra -F -d time,3,144,4 /raid3/jiawei/homero/data/cru/Prec.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.Autumn.nc
ncra -F -d time,4,144,4 /raid3/jiawei/homero/data/cru/Prec.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pre1950.Winter.nc

ncra -F -d time,5,244,4 /raid3/jiawei/homero/data/cru/Prec.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.Spring.nc
ncra -F -d time,2,244,4 /raid3/jiawei/homero/data/cru/Prec.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.Summer.nc
ncra -F -d time,3,244,4 /raid3/jiawei/homero/data/cru/Prec.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.Autumn.nc
ncra -F -d time,4,244,4 /raid3/jiawei/homero/data/cru/Prec.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Prec.pos1950.Winter.nc

ncra -F -d time,5,144,4 /raid3/jiawei/homero/data/cru/Tmax.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.Spring.nc
ncra -F -d time,2,144,4 /raid3/jiawei/homero/data/cru/Tmax.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.Summer.nc
ncra -F -d time,3,144,4 /raid3/jiawei/homero/data/cru/Tmax.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.Autumn.nc
ncra -F -d time,4,144,4 /raid3/jiawei/homero/data/cru/Tmax.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pre1950.Winter.nc

ncra -F -d time,5,244,4 /raid3/jiawei/homero/data/cru/Tmax.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.Spring.nc
ncra -F -d time,2,244,4 /raid3/jiawei/homero/data/cru/Tmax.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.Summer.nc
ncra -F -d time,3,244,4 /raid3/jiawei/homero/data/cru/Tmax.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.Autumn.nc
ncra -F -d time,4,244,4 /raid3/jiawei/homero/data/cru/Tmax.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmax.pos1950.Winter.nc

ncra -F -d time,5,144,4 /raid3/jiawei/homero/data/cru/Tmin.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.Spring.nc
ncra -F -d time,2,144,4 /raid3/jiawei/homero/data/cru/Tmin.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.Summer.nc
ncra -F -d time,3,144,4 /raid3/jiawei/homero/data/cru/Tmin.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.Autumn.nc
ncra -F -d time,4,144,4 /raid3/jiawei/homero/data/cru/Tmin.pre1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pre1950.Winter.nc

ncra -F -d time,5,244,4 /raid3/jiawei/homero/data/cru/Tmin.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.Spring.nc
ncra -F -d time,2,244,4 /raid3/jiawei/homero/data/cru/Tmin.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.Summer.nc
ncra -F -d time,3,244,4 /raid3/jiawei/homero/data/cru/Tmin.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.Autumn.nc
ncra -F -d time,4,244,4 /raid3/jiawei/homero/data/cru/Tmin.pos1950.seasmean.nc /raid3/jiawei/homero/data/cru/Tmin.pos1950.Winter.nc
