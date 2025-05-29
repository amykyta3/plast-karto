#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools
cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

x_min=82804
x_max=82812

y_min=178368
y_max=178381

#-------------------------------------------------------------------------------
# Google Maps
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv -O downloads/google_${y}_${x}.jpg "https://khms1.googleapis.com/kh?v=994&hl=en-US&x=${x}&y=${y}&z=${z}"
    done
done
#wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/google_*.jpg processed/google.jpg

$tools/create_worldfile.py $z $x_min $y_min > processed/google.jgw
