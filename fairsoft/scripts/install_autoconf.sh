#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d  $SIMPATH/tools/autoconf ]; then 
    cd $SIMPATH/tools
    untar autoconf $AUTOCONF_VERSION.tar.gz 
    if [ -d $AUTOCONF_VERSION ]; then
        ln -s $AUTOCONF_VERSION autoconf
    fi
fi 

cd $SIMPATH/tools/autoconf
./configure --prefix=$SIMPATH_INSTALL
make -j4
make -j4 install
  
cd  $SIMPATH
