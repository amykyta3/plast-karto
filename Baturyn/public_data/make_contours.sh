#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
tools=$this_dir/../../tools
cd $this_dir

# NOTE: DEM-smoothed is created using GIMP by applying a 3-pixel gaussian blur
gdal_contour -a elevation -i 1.0 processed/DEM-gaussian3.tif processed/contours-1m.gpkg
gdal_contour -a elevation -i 5.0 processed/DEM-gaussian3.tif processed/contours-5m.gpkg
