# GIS Tools

Folder for various GIS tools and scripts.


## LAStools
LiDAR processing tools from https://lastools.github.io

To download and compile the toolchain, run [setup_LAStools.sh](setup_LAStools.sh).

Alternatively do it manually:
* Download `LAStools.zip`
* Unzip into this folder.
* `cd LAStools/`, Run `make`

**Note:** This is an awkward mix of open-source and closed-source tools. `make`
will compile all of the open-source binaries. The zip contains Windows EXEs for
the remaining closed-source tools. These can be run via wine without any major
issues.


## MrSID SDK
MrSID is a fancy [multiresolution image format](https://en.wikipedia.org/wiki/MrSID).

Unfortunately there are no open source implementations for it yet, so you have
to use a [proprietary Decode SDK](https://www.extensis.com/support/developers)
to extract image data. There is no obvious way to download the latest version
of the DSDK, but I was able to find downloads for their older versions here:
https://www.extensis.com/support/developers/retired-sdks

Since I don't totally trust that the above link will always be viable, I have
downloaded and archived the 9.5.1 SDK locally.

The MrSID DSDK includes the `mrsidinfo` and `mrsiddecode` executables that can
be used to extract/convert imagery into more friendly file formats.
