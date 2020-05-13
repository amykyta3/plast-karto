# Source GIS Data
This folder contains original data files in their (mostly) unaltered forms.

## OGRIP LiDAR
[OSIP_GEA_LiDAR/](OSIP_GEA_LiDAR)

LiDAR elevation scan data
https://ogrip.oit.ohio.gov/ProjectsInitiatives/OSIPDataDownloads.aspx

Due to the file size, source LiDAR data is not included.
Full download (3.3 GB): http://gis3.oit.ohio.gov/ZIPARCHIVES/ELEVATION/LIDAR/OSIP_GEA_LiDAR.zip

LiDAR data was post-processed using LAStools and their respective
output products checked in to the [processed/](processed) folder. To re-run this operation, see [process_lidar_data.sh](process_lidar_data.sh).

Highlights from metadata: (See XML files)
* Surveyed March-May 2006
* All units in feet
* 5,000' x 5,000' LiDAR Tiles
* +/- 1-foot vertical accuracy
* The average post spacing between LiDAR points is 7-feet
* Projection: EPSG:102722 - NAD_1983_StatePlane_Ohio_North_FIPS_3401_Feet


## OGRIP SID Imagery
Acquired via: https://ogrip.oit.ohio.gov/ProjectsInitiatives/OSIPDataDownloads.aspx

Due to the large file sizes, the actual sid image files are not included.

* OSIP I (1.2 GB): http://gis3.oit.ohio.gov/ZIPARCHIVES/IMAGERY/1FTSIDMOSAIC/Geauga.sid.zip
* OSIP II (1.5 GB): http://gis5.oit.ohio.gov/ZIPARCHIVES_II/IMAGERY/1FTSIDMOSAIC/Geauga_rgb_30x.sid.zip
* OSIP III (8.9 GB): http://gis5.oit.ohio.gov/ZIPARCHIVES_III/IMAGERY/6INSIDMOSAIC/Geauga_2017_6IN_rgb_20x_SID.zip

Used MrSID DSDK to extract the PK region imagery and convert to JPEG + a
worldfile. Extracted imagery is checked in to the [processed/](processed) folder.
To re-run this operation, see [process_sid_imagery.sh](process_sid_imagery.sh).

### OSIP I
[Geauga.sid/](Geauga.sid)

Highlights from metadata: (See XML file)
* Surveyed 2006, March-April (leaf-off conditions).
* 12-inch pixel resolution.
* 5.0-foot horizontal accuracy.
* Projection: EPSG:102722 - NAD_1983_StatePlane_Ohio_North_FIPS_3401_Feet

### OSIP II
[Geauga_rgb_30x.sid/](Geauga_rgb_30x.sid)

Highlights from metadata: (See XML file)
* Surveyed 2011, March-April (leaf-off conditions).
* 12-inch pixel resolution.
* 5.0-foot horizontal accuracy.
* Projection: EPSG:102722 - NAD_1983_StatePlane_Ohio_North_FIPS_3401_Feet

### OSIP III
[Geauga_2017_6IN_rgb_20x_SID/](Geauga_2017_6IN_rgb_20x_SID)

Highlights from metadata: (See XML file)
* Surveyed 2017 (leaf-off conditions).
* 6-inch pixel resolution.
* +/- 3.7 feet horizontal accuracy.
* Projection: EPSG:102722 - NAD_1983_StatePlane_Ohio_North_FIPS_3401_Feet

## Parcel Shapefile
[Parcels-January2020/](Parcels-January2020)

https://auditor.co.geauga.oh.us/GIS/Downloads

Downloaded the latest parcel shapefiles of Geauga county. Edited them down in
QGIS to only include the immediate surroundings.
