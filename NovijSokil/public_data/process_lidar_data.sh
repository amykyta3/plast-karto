#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

LAStools=../../tools/LAStools/bin


mkdir -p downloads
mkdir -p tmp
mkdir -p processed

#-------------------------------------------------------------------------------
# Download LiDAR tiles

cd downloads
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10509400.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10509450.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10559400.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10559450.las
cd ..

#-------------------------------------------------------------------------------

# Merge tiles together
$LAStools/lasmerge \
    -sp83 NY_W -feet -elevation_feet \
    -i \
    downloads/10509400.las \
    downloads/10509450.las \
    downloads/10559400.las \
    downloads/10559450.las \
    -o tmp/merged.las

# Crop down to Sokil region
$LAStools/las2las -keep_xy 1054000 944000 1059000 948000 -i tmp/merged.las -o tmp/cropped.las

#-------------------------------------------------------------------------------

# Filter out ground points for elevation maps
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-ft.las -keep_class 2
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2 -scale_z 0.3048

#-------------------------------------------------------------------------------
# Create a vegitation height map raster

wine $LAStools/lasheight -cpu64 -replace_z -i tmp/cropped.las -o tmp/veg-height.las -drop_below 1.0
wine $LAStools/las2dem -cpu64 -i tmp/veg-height.las -o processed/veg-heightmap.jpg -false -kill 10 -step 2

#-------------------------------------------------------------------------------
# Generate hill shading image
wine $LAStools/las2dem -cpu64 -i tmp/elev-ft.las -o processed/hillshade.png -hillshade

#-------------------------------------------------------------------------------
# Generate ground intensity raster
wine $LAStools/las2dem -cpu64 -i tmp/elev-ft.las -o processed/ground-intensity.jpg -intensity -step 2

#-------------------------------------------------------------------------------
# Generate isocontours from ground elevation data

wine $LAStools/las2iso -cpu64 -i tmp/elev-ft.las -o processed/iso-5ft.shp -iso_every 5 -smooth 10 -clean 100
wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o processed/iso-1m.shp -iso_every 1 -smooth 4 -clean 30
