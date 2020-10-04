#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

mkdir -p processed

#-------------------------------------------------------------------------------
# Get parcel boundaries
#-------------------------------------------------------------------------------
# Uses EPSG:3857
# Values manually extracted from map viewer GET request.
# API gets mad if these don't "look right" in some unknown way
# Multiplied width/height x2
x_min=-8059485.676831091
y_min=5646559.902569828

x_max=-8055288.806246808
y_max=5649173.093474328
width=3514
height=2188
pixel_scale=$(python3 -c "print((${x_max} - ${x_min}) / ${width})")

bbox="${x_min}%2C${y_min}%2C${x_max}%2C${y_max}"

wget -nc -nv -O processed/parcels.png \
    --header="Host: geoegl.msp.gouv.qc.ca" \
    --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0" \
    --header="Accept: image/avif,image/webp,image/png,image/svg+xml,image/*;q=0.8,*/*;q=0.5" \
    --header="Accept-Language: en-US,en;q=0.5" \
    --header="Accept-Encoding: gzip, deflate, br, zstd" \
    --header="Referer: https://www.foretouverte.gouv.qc.ca/" \
    --header="Origin: https://www.foretouverte.gouv.qc.ca" \
    --header="DNT: 1" \
    --header="Sec-GPC: 1" \
    --header="Connection: keep-alive" \
    --header="Sec-Fetch-Dest: image" \
    --header="Sec-Fetch-Mode: cors" \
    --header="Sec-Fetch-Site: same-site" \
    "https://geoegl.msp.gouv.qc.ca/apis/mern/cadastre?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS=WMS_FONCIER%3ALotCadastre&CRS=EPSG%3A3857&STYLES=&WIDTH=${width}&HEIGHT=${height}&BBOX=${bbox}"

# Make world file
rm -f processed/parcels.pgw
# Line 1: pixel size in the x-direction in map units/pixel
echo $pixel_scale >> processed/parcels.pgw
# Line 2: rotation about y-axis
echo 0.0 >> processed/parcels.pgw
# Line 3: rotation about x-axis
echo 0.0 >> processed/parcels.pgw
# Line 4: pixel size in the y-direction in map units, almost always negative[b]
echo -$pixel_scale >> processed/parcels.pgw
# Line 5: x-coordinate of the center of the upper left pixel
echo $x_min >> processed/parcels.pgw
# Line 6: y-coordinate of the center of the upper left pixel
echo $y_max >> processed/parcels.pgw
