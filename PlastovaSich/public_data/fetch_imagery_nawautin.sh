#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools
cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

x_min=148503
x_max=148512

y_min=190697
y_max=190709

#-------------------------------------------------------------------------------
# Google Maps
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv -O downloads/google_nawautin_${y}_${x}.jpg "https://khms1.googleapis.com/kh?v=927&hl=en-US&x=${x}&y=${y}&z=${z}" &
        sleep 1
    done
done
wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/google_nawautin_*.jpg processed/google_nawautin.jpg

$tools/create_worldfile.py $z $x_min $y_min > processed/google_nawautin.jgw
