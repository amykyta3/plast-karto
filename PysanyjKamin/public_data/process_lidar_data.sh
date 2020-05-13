#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

LAStools=../../tools/LAStools/bin

# Create a tmp dir for intermediate files
mkdir -p tmp

mkdir -p processed

# Source LAS files are not tagged with the projection or units they use.
# According to the XML, they use NAD_1983_CORS_StatePlane_Ohio_North_FIPS_3401
# and the source units are all in feet
# Tag them with the missing metadata
$LAStools/las2las -sp83 OH_N -feet -elevation_feet -i OSIP_GEA_LiDAR/N2365640.las -o tmp/N2365640.las
$LAStools/las2las -sp83 OH_N -feet -elevation_feet -i OSIP_GEA_LiDAR/N2365645.las -o tmp/N2365645.las
$LAStools/las2las -sp83 OH_N -feet -elevation_feet -i OSIP_GEA_LiDAR/N2370640.las -o tmp/N2370640.las
$LAStools/las2las -sp83 OH_N -feet -elevation_feet -i OSIP_GEA_LiDAR/N2370645.las -o tmp/N2370645.las

# Merge the four tiles that contain the PK region
$LAStools/lasmerge \
    -i \
    tmp/N2365640.las \
    tmp/N2365645.las \
    tmp/N2370640.las \
    tmp/N2370645.las \
    -o tmp/merged.las

# Crop down to PK region:
# las files are using the state plane coordinate system
# Convert lat/lon to state plane coordinates in feet: http://www.earthpoint.us/StatePlane.aspx
    # Min: 2368500, 643500
    # Max: 2373000, 648500
$LAStools/las2las -keep_xy 2368500 643500 2373000 648500 -i tmp/merged.las -o tmp/cropped.las

# filter out only ground/low vegitation points
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-ft.las -keep_class 2
$LAStools/las2las -i tmp/cropped.las -o tmp/elev-m.las -keep_class 2 -scale_z 0.3048 -target_elevation_meter
#-------------------------------------------------------------------------------
# Create a vegitation height map

# This zeros the ground-level elevation, leaving only tree/etc height
wine $LAStools/lasheight -replace_z -i tmp/cropped.las -o tmp/pk-height.las -drop_below 1.0

# Rasterize for QGIS
wine $LAStools/las2dem -i tmp/pk-height.las -o processed/veg-heightmap.jpg -false -kill 5

#-------------------------------------------------------------------------------
# Generate hill shading image
wine $LAStools/las2dem -i tmp/elev-ft.las -o processed/hillshade.png -hillshade

# Generate ground intensity raster
wine $LAStools/las2dem -i tmp/elev-ft.las -o processed/ground-intensity.jpg -intensity

#-------------------------------------------------------------------------------
# Generate isocontours from ground elevation data

wine $LAStools/las2iso -i tmp/elev-ft.las -o processed/iso-5ft.shp -iso_every 5 -smooth 2 -clean 100
wine $LAStools/las2iso -i tmp/elev-m.las -o processed/iso-1m.shp -iso_every 1 -smooth 1 -clean 30
