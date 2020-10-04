#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

LAStools=$this_dir/../../tools/LAStools/bin


mkdir -p downloads
mkdir -p tmp
mkdir -p processed

#-------------------------------------------------------------------------------
# Download LiDAR tiles

function dl_laz {
    set +e
    root_url=http://geo1.scholarsportal.info/proxy.html?http://maps.scholarsportal.info/raster2/data28/Peterborough_LiDAR_CPC/Ptbo_Received_May_2020_Current
    wget -nc -nv -v -O $1 ${root_url}/$1
    set -e
}

cd downloads
dl_laz 1km177360487402017LPETERBOROUGH.laz
dl_laz 1km177360487302017LPETERBOROUGH.laz
dl_laz 1km177360487202017LPETERBOROUGH.laz
dl_laz 1km177370487402017LPETERBOROUGH.laz
dl_laz 1km177370487302017LPETERBOROUGH.laz
dl_laz 1km177370487202017LPETERBOROUGH.laz
dl_laz 1km177380487402017LPETERBOROUGH.laz
dl_laz 1km177380487302017LPETERBOROUGH.laz
dl_laz 1km177380487202017LPETERBOROUGH.laz
cd ..

#-------------------------------------------------------------------------------
# Unzip tiles
$LAStools/laszip -i downloads/1km177360487402017LPETERBOROUGH.laz -o downloads/1km177360487402017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177360487302017LPETERBOROUGH.laz -o downloads/1km177360487302017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177360487202017LPETERBOROUGH.laz -o downloads/1km177360487202017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177370487402017LPETERBOROUGH.laz -o downloads/1km177370487402017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177370487302017LPETERBOROUGH.laz -o downloads/1km177370487302017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177370487202017LPETERBOROUGH.laz -o downloads/1km177370487202017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177380487402017LPETERBOROUGH.laz -o downloads/1km177380487402017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177380487302017LPETERBOROUGH.laz -o downloads/1km177380487302017LPETERBOROUGH.las
$LAStools/laszip -i downloads/1km177380487202017LPETERBOROUGH.laz -o downloads/1km177380487202017LPETERBOROUGH.las

#-------------------------------------------------------------------------------

# Merge tiles together
$LAStools/lasmerge \
    -i \
    downloads/1km177360487402017LPETERBOROUGH.las \
    downloads/1km177360487302017LPETERBOROUGH.las \
    downloads/1km177360487202017LPETERBOROUGH.las \
    downloads/1km177370487402017LPETERBOROUGH.las \
    downloads/1km177370487302017LPETERBOROUGH.las \
    downloads/1km177370487202017LPETERBOROUGH.las \
    downloads/1km177380487402017LPETERBOROUGH.las \
    downloads/1km177380487302017LPETERBOROUGH.las \
    downloads/1km177380487202017LPETERBOROUGH.las \
    -o tmp/merged.las

# Crop down
# Create a second shifted copy of everything to work around the black diagonal stripe
$LAStools/las2las -keep_xy 736700 4872500 738500 4874200 -i tmp/merged.las -o tmp/cropped.las
$LAStools/las2las -keep_xy 736710 4872500 738500 4874200 -i tmp/merged.las -o tmp/cropped-shifted.las

#-------------------------------------------------------------------------------

# Filter out ground points for elevation maps
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2
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
wine $LAStools/las2dem -cpu64 -i tmp/elev-m.las -o processed/ground-intensity.png -intensity -gray
wine $LAStools/las2dem -cpu64 -i tmp/elev-m-shifted.las -o tmp/ground-intensity-shifted.png -intensity -gray

# Clean up diagonals
convert tmp/ground-intensity-shifted.png -fuzz 0% -transparent black tmp/ground-intensity-shifted-trans.png
composite -geometry +10+0 tmp/ground-intensity-shifted-trans.png processed/ground-intensity.png processed/ground-intensity.png
#-------------------------------------------------------------------------------

wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o processed/iso-0.5m.shp \
    -iso_every 0.5 -smooth 100 -clean 100 -simplify 2

wine $LAStools/las2iso -cpu64 -i tmp/elev-m.las -o processed/iso-1m.shp \
    -iso_every 1 -smooth 100 -clean 100 -simplify 2
