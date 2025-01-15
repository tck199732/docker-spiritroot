#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh



cd $SIMPATH/basics/mesa
./configure --prefix=$SIMPATH_INSTALL --with-driver=xlib --disable-gallium

LDFLAGS="-stdlib=libc++" make -j4

make install

unset LDFLAGS

cd $SIMPATH
