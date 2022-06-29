#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools
cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

x_min=148475
x_max=148510

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

$tools/create_worldfile.py $z $x_min $y_min > processed/scoop_2018.jgw

#-------------------------------------------------------------------------------
# Maxar (?)
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv -O downloads/maxar_${y}_${x}.jpg https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/$z/$y/$x &
    done
done
wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/maxar*.jpg processed/maxar.jpg

$tools/create_worldfile.py $z $x_min $y_min > processed/maxar.jgw

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

$tools/create_worldfile.py $z $x_min $y_min > processed/google.jgw
