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
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6210069350_2016.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6225069350_2016.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6210069200_2016.las
wget -nc -nv ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6225069200_2016.las
cd ..

#-------------------------------------------------------------------------------

# Merge tiles together
$LAStools/lasmerge \
    -i \
    downloads/u_6210069200_2016.las \
    downloads/u_6210069350_2016.las \
    downloads/u_6225069200_2016.las \
    downloads/u_6225069350_2016.las \
    -o tmp/merged.las

# Crop down to Vovcha region
# Create a second shifted copy of everything to work around the black diagonal stripe
$LAStools/las2las -keep_xy 621300 4693100 623400 4694700 -i tmp/merged.las -o tmp/cropped.las
$LAStools/las2las -keep_xy 621310 4693100 623400 4694700 -i tmp/merged.las -o tmp/cropped-shifted.las

#-------------------------------------------------------------------------------

# Filter out ground points for elevation maps
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-ft.las -keep_class 2 -scale_z 3.28084
$LAStools/las2las -i tmp/cropped-shifted.las -o tmp/elev-m-shifted.las -keep_class 2

#-------------------------------------------------------------------------------
# Create a vegitation height map raster

wine $LAStools/lasheight -cpu64 -replace_z -i tmp/cropped.las -o tmp/veg-height.las -drop_below 1.0
wine $LAStools/lasheight -cpu64 -replace_z -i tmp/cropped-shifted.las -o tmp/veg-height-shifted.las -drop_below 1.0

wine $LAStools/las2dem -cpu64 -i tmp/veg-height.las -o processed/veg-heightmap.png -false -kill 3
wine $LAStools/las2dem -cpu64 -i tmp/veg-height-shifted.las -o tmp/veg-heightmap-shifted.png -false -kill 3

# Clean up diagonals
convert tmp/veg-heightmap-shifted.png -fuzz 0% -transparent black tmp/veg-heightmap-shifted-trans.png
composite -geometry +10+0 tmp/veg-heightmap-shifted-trans.png processed/veg-heightmap.png processed/veg-heightmap.png
convert -background black -alpha remove processed/veg-heightmap.png processed/veg-heightmap.png

#-------------------------------------------------------------------------------
# Generate hill shading image
wine $LAStools/las2dem -cpu64 -i tmp/elev-m.las -o processed/hillshade.png -hillshade
wine $LAStools/las2dem -cpu64 -i tmp/elev-m-shifted.las -o tmp/hillshade-shifted.png -hillshade

# Clean up diagonals
convert tmp/hillshade-shifted.png -fuzz 0% -transparent black tmp/hillshade-shifted-trans.png
composite -geometry +10+0 tmp/hillshade-shifted-trans.png processed/hillshade.png processed/hillshade.png

#-------------------------------------------------------------------------------
# Generate ground intensity raster
wine $LAStools/las2dem -cpu64 -i tmp/elev-m.las -o processed/ground-intensity.png -intensity
wine $LAStools/las2dem -cpu64 -i tmp/elev-m-shifted.las -o tmp/ground-intensity-shifted.png -intensity

# Clean up diagonals
convert tmp/ground-intensity-shifted.png -fuzz 0% -transparent black tmp/ground-intensity-shifted-trans.png
composite -geometry +10+0 tmp/ground-intensity-shifted-trans.png processed/ground-intensity.png processed/ground-intensity.png
#-------------------------------------------------------------------------------

wine $LAStools/las2iso -cpu64 -i tmp/elev-ft.las -o processed/iso-5ft.shp \
    -iso_every 5 -smooth 10 -clean 100 -simplify 2

wine $LAStools/las2iso -cpu64 -i tmp/elev-ft.las -o processed/iso-10ft.shp \
    -iso_every 10 -smooth 10 -clean 100 -simplify 2

wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o processed/iso-1m.shp \
    -iso_every 1 -smooth 4 -clean 30 -simplify 1

wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o processed/iso-2m.shp \
    -iso_every 2 -smooth 4 -clean 30 -simplify 1
