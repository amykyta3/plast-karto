#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

LAStools=../../tools/LAStools/bin

out=processed/2019NY_LiDAR
mkdir -p downloads
mkdir -p tmp
mkdir -p $out

#-------------------------------------------------------------------------------
# Download LiDAR tiles
prefix=ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ErieGeneseeLivingston2019

cd downloads
wget -nc -nv -v $prefix/e1384n2301_2019.las
wget -nc -nv -v $prefix/e1384n2302_2019.las
wget -nc -nv -v $prefix/e1385n2301_2019.las
wget -nc -nv -v $prefix/e1385n2302_2019.las
cd ..

#-------------------------------------------------------------------------------

# Merge tiles together
$LAStools/lasmerge \
    -i \
    downloads/e1384n2301_2019.las \
    downloads/e1384n2302_2019.las \
    downloads/e1385n2301_2019.las \
    downloads/e1385n2302_2019.las \
    -o tmp/merged.las

# Crop down to Sokil region
# Create a second shifted copy of everything to work around the black diagonal stripe
$LAStools/las2las -keep_xy 1384750 2301750 1386000 2303000 -i tmp/merged.las -o tmp/cropped.las
$LAStools/las2las -keep_xy 1384760 2301750 1386000 2303000 -i tmp/merged.las -o tmp/cropped-shifted.las

#-------------------------------------------------------------------------------

# Filter out ground points for elevation maps
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-ft.las -keep_class 2 -scale_z 3.28084
$LAStools/las2las -i tmp/cropped-shifted.las -o tmp/elev-m-shifted.las -keep_class 2

#-------------------------------------------------------------------------------
# Create a vegitation height map raster

wine $LAStools/lasheight -cpu64 -replace_z -i tmp/cropped.las -o tmp/veg-height.las -drop_below 1.0
wine $LAStools/lasheight -cpu64 -replace_z -i tmp/cropped-shifted.las -o tmp/veg-height-shifted.las -drop_below 1.0

wine $LAStools/las2dem -cpu64 -i tmp/veg-height.las -o $out/veg-heightmap.png -false -kill 3
wine $LAStools/las2dem -cpu64 -i tmp/veg-height-shifted.las -o tmp/veg-heightmap-shifted.png -false -kill 3

# Clean up diagonals
convert tmp/veg-heightmap-shifted.png -fuzz 0% -transparent black tmp/veg-heightmap-shifted-trans.png
composite -geometry +10+0 tmp/veg-heightmap-shifted-trans.png $out/veg-heightmap.png $out/veg-heightmap.png
convert -background black -alpha remove $out/veg-heightmap.png $out/veg-heightmap.png

#-------------------------------------------------------------------------------
# Generate hill shading image
wine $LAStools/las2dem -cpu64 -i tmp/elev-m.las -o $out/hillshade.png -hillshade
wine $LAStools/las2dem -cpu64 -i tmp/elev-m-shifted.las -o tmp/hillshade-shifted.png -hillshade

# Clean up diagonals
convert tmp/hillshade-shifted.png -fuzz 0% -transparent black tmp/hillshade-shifted-trans.png
composite -geometry +10+0 tmp/hillshade-shifted-trans.png $out/hillshade.png $out/hillshade.png

#-------------------------------------------------------------------------------
# (Removed. No useful data)
# Generate ground intensity raster
#wine $LAStools/las2dem -cpu64 -i tmp/elev-m.las -o $out/ground-intensity.png -intensity
#wine $LAStools/las2dem -cpu64 -i tmp/elev-m-shifted.las -o tmp/ground-intensity-shifted.png -intensity

# Clean up diagonals
#convert tmp/ground-intensity-shifted.png -fuzz 0% -transparent black tmp/ground-intensity-shifted-trans.png
#composite -geometry +10+0 tmp/ground-intensity-shifted-trans.png $out/ground-intensity.png $out/ground-intensity.png

#-------------------------------------------------------------------------------
# Generate isocontours from ground elevation data

wine $LAStools/las2iso -cpu64 -i tmp/elev-ft.las -o $out/iso-5ft.shp \
    -iso_every 5 -smooth 50 -clean 100 -simplify 1

wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o $out/iso-1m.shp \
    -iso_every 1 -smooth 50 -clean 100 -simplify 1
