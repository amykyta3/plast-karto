#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools

cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

x_min=144123
x_max=144137

y_min=195725
y_max=195746

version=923

#-------------------------------------------------------------------------------
# Google Maps
#-------------------------------------------------------------------------------
# download tiles
set +e
for x in $(seq $x_min $x_max); do
    for y in $(seq $y_min $y_max); do
        wget -nc -nv --random-wait -O downloads/google_${y}_${x}.jpg "https://khms1.googleapis.com/kh?v=${version}&hl=en-US&x=${x}&y=${y}&z=${z}"
        if [ $? -eq 8 ]; then
            rm downloads/google_${y}_${x}.jpg
            exit 1
        fi
    done
done
wait
set -e

# Merge tiles
x_range=$(($x_max - $x_min + 1))
y_range=$(($y_max - $y_min + 1))
montage -mode concatenate -tile ${x_range}x${y_range} downloads/google_*.jpg processed/google.jpg

$tools/create_worldfile.py $z $x_min $y_min > processed/google.jgw
