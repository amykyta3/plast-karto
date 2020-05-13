#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

mkdir -p processed

MrSID=../../tools/MrSID_DSDK-9.5.1.4427-linux.x86-64.gcc48/Raster_DSDK/bin
export LD_LIBRARY_PATH=../../tools/MrSID_DSDK-9.5.1.4427-linux.x86-64.gcc48/Raster_DSDK/lib

# Dump additional file info and metadata
$MrSID/mrsidinfo -i Geauga.sid/Geauga.sid -meta > Geauga.sid/sid-metadata.txt
$MrSID/mrsidinfo -i Geauga_rgb_30x.sid/Geauga_rgb_30x.sid -meta > Geauga_rgb_30x.sid/sid-metadata.txt
$MrSID/mrsidinfo -i Geauga_2017_6IN_rgb_20x_SID/Geauga_2017_rgb_20x.sid -meta > Geauga_2017_6IN_rgb_20x_SID/sid-metadata.txt

# Extract PK region from SID files
# Ideally I'd use GeoTIFF but I cant figure out a way to compress it with
# ImageMagick and not discard the geolocation metadata.
# Instead, converting to JPEG + a Worldfile (.jgw)
# Images need to be imported to QGIS using the correct CRS (OH North FIPS 3401)
# so that the worldfile can geolocate it correctly.
$MrSID/mrsiddecode -i Geauga.sid/Geauga.sid -o processed/pk-osip-i.jpg -of jpg -wf \
    -coord geo \
    -lrxy 2373000 643500 \
    -ulxy 2368500 648500

$MrSID/mrsiddecode -i Geauga_rgb_30x.sid/Geauga_rgb_30x.sid -o processed/pk-osip-ii.jpg -of jpg -wf \
    -coord geo \
    -lrxy 2373000 643500 \
    -ulxy 2368500 648500

$MrSID/mrsiddecode -i Geauga_2017_6IN_rgb_20x_SID/Geauga_2017_rgb_20x.sid -o processed/pk-osip-iii.jpg -of jpg -wf \
    -coord geo \
    -lrxy 2373000 643500 \
    -ulxy 2368500 648500
