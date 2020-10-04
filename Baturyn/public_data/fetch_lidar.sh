#!/bin/bash
set -e
this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

mkdir -p downloads
mkdir -p processed

#-------------------------------------------------------------------------------
# Download data
#-------------------------------------------------------------------------------

function dl_file {
    filename=$1
    prefix="https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/IMAGERIE/Produits_derives_LiDAR/31H/31H01NO"
    echo "Downloading ${filename} ..."
    set +e
    wget -nc -nv -O downloads/${filename} ${prefix}/${filename}
    set -e
}

dl_file MHC_31H01NO.tif
dl_file MNT_31H01NO.tif

#-------------------------------------------------------------------------------
# Crop to more sensible region
#-------------------------------------------------------------------------------
ulx=392080
uly=5004515
lrx=394040
lry=5002615
gdal_translate -epo -projwin $ulx $uly $lrx $lry downloads/MHC_31H01NO.tif processed/canopy.tif
gdal_translate -epo -projwin $ulx $uly $lrx $lry downloads/MNT_31H01NO.tif processed/DEM.tif

#-------------------------------------------------------------------------------
gdaldem hillshade processed/DEM.tif processed/hillshade.tif
