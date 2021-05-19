# Source GIS Data
This folder contains original data files in their (mostly) unaltered forms.

## NYS Digital Ortho Imagery Program
http://gis.ny.gov/

Imagery was downloaded and committed in its unaltered form.

### NYSDOP8
[nysdop8/](nysdop8)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop8/erie/spcs/tiles/w_10530944_12_17100_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/erie/spcs/tiles/w_10560944_12_17100_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/erie/spcs/tiles/w_10530946_12_17100_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/erie/spcs/tiles/w_10560946_12_17100_4bd_2017.zip

Highlights from metadata:
* Surveyed April 2017
* 12-inch pixel resolution.
* +/- 4 feet horizontal accuracy.
* 4-band RGB + NIR

### NYSDOP7
[nysdop7/](nysdop7)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop7/erie/spcs/tiles/w_10530946_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/erie/spcs/tiles/w_10560946_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/erie/spcs/tiles/w_10530944_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/erie/spcs/tiles/w_10560944_12_15100_4bd_2014.zip

Highlights from metadata:
* Surveyed April 2014
* 12-inch pixel resolution.
* +/- 4 feet horizontal accuracy.
* 4-band RGB + NIR

### NYSDOP5
[nysdop5/](nysdop5)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop5/erie/spcs/tiles/w_10500944_24_19200_4bd_2011.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop5/erie/spcs/tiles/w_10560944_24_19200_4bd_2011.zip

Highlights from metadata:
* Surveyed April 2011
* 24-inch pixel resolution.
* +/- 8 feet horizontal accuracy.
* 4-band RGB + NIR



## NYSGPO LiDAR
http://gis.ny.gov/

Source tiles are not included due to their size but can be downloaded from:
* ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10509400.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10509450.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10559400.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/County_Erie2008/10559450.las

Instead, tiles were downloaded temporarily and processed into their respective
output products in [processed/](processed). To re-run this operation, see [process_lidar_data.sh](process_lidar_data.sh).

Highlights from metadata:
* Surveyed April 2008
* Nominal point spacing: 1.4 meters
* Horizontal accuracy: 1.0 meters
* Vertical accuracy: 0.37 meters
* Projection: EPSG:103119 - NAD_1983_2011_StatePlane_New_York_West_FIPS_3103_Ft_US

## Parcel Shapefile
[NYS-Tax-Parcels-SHP/](NYS-Tax-Parcels-SHP)

http://gis.ny.gov/parcels/

Downloaded the latest parcel shapefile of Erie county. Edited it down in
QGIS to only include the immediate surroundings.

Full download: http://gis.ny.gov/gisdata/fileserver/?DSID=1300&file=NYS-Tax-Parcels-SHP.zip
