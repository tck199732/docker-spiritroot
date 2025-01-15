#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d  $SIMPATH/tools/libtool ]; then 
    cd $SIMPATH/tools
    untar libtool $LIBTOOL_VERSION.tar.gz 
    if [ -d $LIBTOOL_VERSION ]; then
        ln -s $LIBTOOL_VERSION libtool
    fi
fi 

cd $SIMPATH/tools/libtool
./configure --prefix=$SIMPATH_INSTALL

make -j4
make -j4 install

cd  $SIMPATH
