#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

x_min=148480
x_max=148505

y_min=190675
y_max=190705

#-------------------------------------------------------------------------------
# SCOOP 2018
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv -O downloads/scoop_2018_${y}_${x}.jpg https://maps.northumberlandcounty.ca/server/rest/services/County_Basemap/MapServer/tile/$z/$y/$x &
    done
done
wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/scoop*.jpg processed/scoop_2018.jpg

./create_worldfile.py $z $x_min $y_min > processed/scoop_2018.jgw

#-------------------------------------------------------------------------------
# Google Maps
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv -O downloads/google_${y}_${x}.jpg "https://khms1.googleapis.com/kh?v=874&hl=en-US&x=${x}&y=${y}&z=${z}" &
    done
done
wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/google_*.jpg processed/google.jpg

./create_worldfile.py $z $x_min $y_min > processed/google.jgw

# See this actually: https://gis.stackexchange.com/questions/2904/how-to-georeference-a-web-mercator-tile-correctly-using-gdal

# See: https://gis.stackexchange.com/questions/188412/how-to-georeference-a-tile-downloaded-from-google-maps