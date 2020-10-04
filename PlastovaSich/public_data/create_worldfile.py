#!/usr/bin/env python3

import math
import sys
from typing import Tuple

tile_size = 256

def lat_lon_from_pixel(pix_x:int, pix_y:int, zoom:int) -> Tuple[float, float]:
    """
    Converts from global pixel coordinates (NW @ alaska = 0,0)
    to lat/lon in degrees
    """
    # Inverse of https://en.wikipedia.org/wiki/Web_Mercator_projection#Formulas
    x_rad = (2 * math.pi * pix_x / (tile_size * 2 ** zoom)) - math.pi
    y_rad = 2 * math.atan(math.exp(math.pi - 2 * math.pi * pix_y / (tile_size * 2 ** zoom))) - math.pi / 2

    # Convert to degrees
    x_deg = x_rad * 180 / math.pi
    y_deg = y_rad * 180 / math.pi

    return (y_deg, x_deg)

zoom, tile_x, tile_y = sys.argv[1:4]
zoom = int(zoom)
tile_x = int(tile_x)
tile_y = int(tile_y)

# Convert tile coordinates to global pixel coordinates
pix_x = tile_x * tile_size
pix_y = tile_y * tile_size

# Convert to lat/lon
y, x = lat_lon_from_pixel(pix_x, pix_y, zoom)

# get units / pixel
yi, xi = lat_lon_from_pixel(pix_x + 1, pix_y + 1, zoom)
y_dpp = yi - y
x_dpp = xi - x

print("%0.16f" % x_dpp)
print("0.0")
print("0.0")
print("%0.16f" % y_dpp)
print(x)
print(y)