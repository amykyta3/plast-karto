#!/usr/bin/env python3

import sys
import math

# usage: lat_lon_to_tile_index 19 -72.37507,45.16751
zoom = int(sys.argv[1])
lon_deg, lat_deg = sys.argv[2].split(",")

lat_deg = float(lat_deg)
lon_deg = float(lon_deg)
lat_rad = (lat_deg / 180) * math.pi

n = 2 ** zoom
x_tile = int(n * ((lon_deg + 180) / 360))
y_tile = int(n * (1 - (math.log(math.tan(lat_rad) + (1 / math.cos(lat_rad))) / math.pi)) / 2)

print(x_tile, y_tile)
