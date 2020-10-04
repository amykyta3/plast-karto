#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools
cd $this_dir

mkdir -p downloads
mkdir -p processed
#-------------------------------------------------------------------------------
z=19

# -72.38897,45.17525
x_min=156719
y_min=188238

# -72.36523,45.15827
x_max=156754
y_max=188273

function dl_tile {
    api=https://servicesmatriciels.mern.gouv.qc.ca/erdas-iws/ogc/wmts
    dataset=$1
    layer=$2
    x=$3
    y=$4

    args="layer=${layer}&style=default&tilematrixset=GoogleMapsCompatibleExt2%3Aepsg%3A3857&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image%2Fjpeg&TileMatrix=${z}&TileCol=${x}&TileRow=${y}"
    url=${api}/${dataset}?${args}

    set +e
    wget -nc -nv -O downloads/${layer}_${y}_${x}.jpg $url
    set -e
}

function get_imagery {
    dataset=$1
    layer=$2

    # download tiles
    for x in $(seq $x_min $x_max); do
        for y in $(seq $y_min $y_max); do
            dl_tile $dataset $layer $x $y &
        done
    done
    wait

    # Merge tiles
    x_range=$(($x_max - $x_min + 1))
    y_range=$(($y_max - $y_min + 1))

    montage -mode concatenate -tile ${x_range}x${y_range} downloads/${layer}_*.jpg processed/${layer}.jpg

    $tools/create_worldfile.py $z $x_min $y_min > processed/${layer}.jgw
}

#-------------------------------------------------------------------------------
get_imagery Imagerie_Aeroportee_Forestiere_Historique   Inventaire_Ecoforestier_2018_2018_Inv_Ecofor_20cm_RVB
get_imagery Imagerie_Aeroportee_Forestiere_Historique   Inventaire_Ecoforestier_2007_2007_Inv_Ecofor_21cm_RVB
get_imagery Imagerie_Continue                           Imagerie_GQ
