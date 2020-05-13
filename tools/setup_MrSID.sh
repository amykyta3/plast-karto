#!/bin/bash

set -e

this_dir="$( cd "$(dirname "$0")" ; pwd -P )"
cd $this_dir

wget -nc -nv http://bin.extensis.com/download/developer/MrSID_DSDK-9.5.1.4427-linux.x86-64.gcc48.tar.gz
tar -xvf MrSID_DSDK-9.5.1.4427-linux.x86-64.gcc48.tar.gz
