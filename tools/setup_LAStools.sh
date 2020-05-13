#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

wget -nc -nv http://lastools.github.io/download/LAStools.zip
unzip LAStools.zip
make -C LAStools
