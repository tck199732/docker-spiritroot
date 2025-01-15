#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d  $SIMPATH/tools/automake ]; then 
    cd $SIMPATH/tools
    untar automake $AUTOMAKE_VERSION.tar.gz 
    if [ -d $AUTOMAKE_VERSION ]; then
        ln -s $AUTOMAKE_VERSION automake
    fi
fi 

cd $SIMPATH/tools/automake

./configure --prefix=$SIMPATH_INSTALL

make -j4
make -j4 install


cd $SIMPATH
