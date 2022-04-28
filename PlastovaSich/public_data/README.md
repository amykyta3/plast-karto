# Source GIS Data
This folder contains original data files in their (mostly) unaltered forms.

## Imagery

Scraped from https://maps.northumberlandcounty.ca/MunicipalServices/

I suspect this is the "2018 SCOOP Aerial Photos" dataset.

The [fetch_imagery.sh](fetch_imagery.sh) downloads map tiles, merges them, and
creates their respective worldfiles using the WGS84 (EPSG:4326) CRS.


## Ontario Classified Point Cloud LiDAR Dataset
https://geohub.lio.gov.on.ca/datasets/mnrf::ontario-classified-point-cloud-lidar-derived?geometry=-80.561%2C43.708%2C-75.321%2C44.399

Source tiles are not included due to their size but can be downloaded from: http://geo1.scholarsportal.info

Instead, tiles were downloaded temporarily and processed into their respective
output products in [processed/](processed). To re-run this operation, see [process_lidar_data.sh](process_lidar_data.sh).

Highlights from metadata:
* Surveyed 2017
* Horizontal accuracy: ~10 cm
* Vertical accuracy: 9.4 cm
* 1.0 foot cell size
* Projection: NAD83CSRS / UTM zone 17N

File naming scheme (from https://www.sdc.gov.on.ca/sites/MNRF-PublicDocs/EN/CMID/Ontario-Class-PC-Lidar-Derived-User-Guide.docx):

```
1km177360487502017LPETERBOROUGH.laz
\_/\/\__/\___/\__/ \__________/
    |  |  |   |    |       |
    |  |  |   |    |       +-- Project
    |  |  |   |    +-- Year
    |  |  |   +-- Northing
    |  |  +-- Easting
    |  +-- UTM Zone
    +-- Tile Size
```

.. note::
    LAZ files appear to no longer be available for public download.
    I have a copy of the tiles stashed away in my archive if needed.


## Parcel Boundaries
From the Пласт Toronto archive (via АҐБ)
