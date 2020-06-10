# Source GIS Data
This folder contains original data files in their (mostly) unaltered forms.

## NYS Digital Ortho Imagery Program
http://gis.ny.gov/

Imagery was downloaded and committed in its unaltered form.

### NYSDOP8
[nysdop8/](nysdop8)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07561294_12_15300_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07561296_12_15300_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07561298_12_15300_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07591294_12_15300_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07591296_12_15300_4bd_2017.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop8/columbia/spcs/tiles/e_07591298_12_15300_4bd_2017.zip

Highlights from metadata:
* Surveyed April 2017
* 12-inch pixel resolution.
* +/- 4 feet horizontal accuracy.
* 4-band RGB + NIR
* Projection: EPSG:2260 - NAD83 / New York East

### NYSDOP7
[nysdop7/](nysdop7)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07561298_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07591298_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07561296_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07591296_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07561294_12_15100_4bd_2014.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop7/columbia/spcs/tiles/e_07591294_12_15100_4bd_2014.zip

Highlights from metadata:
* Surveyed April 2014
* 12-inch pixel resolution.
* +/- 4 feet horizontal accuracy.
* 4-band RGB + NIR
* Projection: EPSG:2260 - NAD83 / New York East

### NYSDOP5
[nysdop5/](nysdop5)

Source files:
* ftp://ftp.gis.ny.gov/ortho/nysdop5/columbia/spcs/tiles/e_07561296_24_19200_4bd_2010.zip
* ftp://ftp.gis.ny.gov/ortho/nysdop5/columbia/spcs/tiles/e_07561292_24_19200_4bd_2010.zip

Highlights from metadata:
* Surveyed April 2010
* 24-inch pixel resolution.
* +/- 8 feet horizontal accuracy.
* 4-band RGB + NIR
* Projection: EPSG:2260 - NAD83 / New York East



## NYSGPO LiDAR
http://gis.ny.gov/

Source tiles are not included due to their size but can be downloaded from:
* ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6210069350_2016.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6225069350_2016.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6210069200_2016.las
* ftp://ftp.gis.ny.gov/elevation/LIDAR/NYSGPO_ColumbiaRensselaer2016/u_6225069200_2016.las

Instead, tiles were downloaded temporarily and processed into their respective
output products in [processed/](processed). To re-run this operation, see [process_lidar_data.sh](process_lidar_data.sh).

Highlights from metadata:
* Surveyed March-May 2006
* Horizontal accuracy: 0.3273 meters
* Vertical accuracy: 0.06 meters
* 1.0 foot cell size
* Projection: EPSG:26918 NAD83 / UTM zone 18N