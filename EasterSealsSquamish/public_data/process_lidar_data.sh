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

# Interactive map: https://lidar.gov.bc.ca/pages/download-discovery
# More info at: https://nrs.objectstore.gov.bc.ca/gdwuts/metadata/accuracy_rpts/2016/l_001_emn_16_summary.pdf
#https://nrs.objectstore.gov.bc.ca/gdwuts/092/092g/2016/dsm/bc_092g075_3_2_1_xyes_8_utm10_20170601_dsm.laz
#https://nrs.objectstore.gov.bc.ca/gdwuts/092/092g/2016/dsm/bc_092g075_1_4_3_xyes_8_utm10_20170601_dsm.laz
#https://nrs.objectstore.gov.bc.ca/gdwuts/092/092g/2016/pointcloud/bc_092g075_3_2_1_xyes_8_utm10_20170601.laz
#https://nrs.objectstore.gov.bc.ca/gdwuts/092/092g/2016/pointcloud/bc_092g075_1_4_3_xyes_8_utm10_20170601.laz

function dl_laz {
    set +e
    root_url=https://nrs.objectstore.gov.bc.ca/gdwuts/092/092g/2016/pointcloud
    wget -nc -nv -v -O $1 ${root_url}/$1
    set -e
}

cd downloads
dl_laz bc_092g075_3_2_1_xyes_8_utm10_20170601.laz
dl_laz bc_092g075_1_4_3_xyes_8_utm10_20170601.laz
cd ..

#-------------------------------------------------------------------------------
# Unzip tiles
wine $LAStools/laszip64 -i downloads/bc_092g075_3_2_1_xyes_8_utm10_20170601.laz -o downloads/bc_092g075_3_2_1_xyes_8_utm10_20170601.las
wine $LAStools/laszip64 -i downloads/bc_092g075_1_4_3_xyes_8_utm10_20170601.laz -o downloads/bc_092g075_1_4_3_xyes_8_utm10_20170601.las

#-------------------------------------------------------------------------------

# Merge tiles together
wine $LAStools/lasmerge64 \
    -i \
    downloads/bc_092g075_3_2_1_xyes_8_utm10_20170601.las \
    downloads/bc_092g075_1_4_3_xyes_8_utm10_20170601.las \
    -o tmp/merged.las

# Crop down
# Datum: NAD83(CSRS):2002
# Projection: UTM 10-N
wine $LAStools/las2las64 -keep_xy 489700 5510400 490150 5511200 -i tmp/merged.las -o tmp/cropped.las

#-------------------------------------------------------------------------------

# Filter out ground points for elevation maps
wine $LAStools/las2las64 -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2

#-------------------------------------------------------------------------------
# Create a vegetation height map raster
wine $LAStools/lasheight64 -replace_z -i tmp/cropped.las -o tmp/veg-height.las -drop_below 1.0 -demo
wine $LAStools/las2dem64 -i tmp/veg-height.las -o processed/veg-heightmap.png -false -kill 3 -demo

#-------------------------------------------------------------------------------
# Generate hill shading image
wine $LAStools/las2dem64 -i tmp/elev-m.las -o processed/hillshade.png -hillshade -demo

#-------------------------------------------------------------------------------
# Generate ground intensity raster
wine $LAStools/las2dem64 -i tmp/elev-m.las -o processed/ground-intensity.png -intensity -gray -demo
#-------------------------------------------------------------------------------

wine $LAStools/las2iso64 -cpu64 -i tmp/elev-m.las -o processed/iso-0.5m.shp \
    -iso_every 0.5 -smooth 100 -clean 100 -simplify 2 -demo

wine $LAStools/las2iso64 -cpu64 -i tmp/elev-m.las -o processed/iso-1m.shp \
    -iso_every 1 -smooth 100 -clean 100 -simplify 2 -demo
