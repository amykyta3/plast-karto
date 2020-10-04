# Source GIS Data
This folder contains original data files in their (mostly) unaltered forms.

## Imagery

Scraped from https://www.foretouverte.gouv.qc.ca/?zoom=14&center=-72.377102,45.168437

The map viewer contains several layers:
* Imagerie aérienne de l'inventaire écoforestier historique / 2018_Inv_Ecofor_20cm_RVB
    * Acquired Summer 2017
    * 20cm resolution
    * From: Inventaire écoforestier du Québec
    * https://www.donneesquebec.ca/recherche/dataset/imagerie-historique
* Imagerie aérienne de l'inventaire écoforestier historique / 2007_Inv_Ecofor_21cm_RVB
    * Acquired Summer 2007
    * 21cm resolution
    * From: Inventaire écoforestier du Québec
    * https://www.donneesquebec.ca/recherche/dataset/imagerie-historique
* Imagerie aérienne partenariat / 2023_Partenariat_Estrie_20cm_RVB
    * Acquired Spring 2023
    * 20cm resolution
    * From: GéoMont

The [fetch_imagery.sh](fetch_imagery.sh) script downloads map tiles, merges them, and
creates their respective worldfiles.

## LiDAR
Québec does not provide LiDAR point clouds. Only raster output products.

Details: https://www.donneesquebec.ca/recherche/fr/dataset/produits-derives-de-base-du-lidar

Metadata:
* Acquired in 2016
* Products made available in 2024
* No leaves conditions
* Quad ID: 31H01NO

https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/IMAGERIE/Produits_derives_LiDAR/31H/31H01NO

The above URL includes several products:
* DEM raster (fr: MNT)
* Canopy height raster (fr: MHC)
* 1m contour vectors (fr: Courbes)
* Hillshade (fr: Relief Ombre)

I am mostly only using the DEM raster and re-deriving hillshade and contours since the products they provide are downsampled significantly.

The [fetch_lidar_data.sh](fetch_lidar_data.sh) script downloads the DEM tile, crops it, and generates hillshade. Afterwards the [make_contours.sh](make_contours.sh) script vectorizes a smoothed DEM to create contours.

## Parcel Boundaries

Scraped from https://www.foretouverte.gouv.qc.ca/?zoom=14&center=-72.377102,45.168437
