#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/spirit_packages.sh
source scripts/config.sh

if [ ! -d $SIMPATH/tools/clhep ]; then
    cd $SIMPATH/tools
    untar clhep clhep-$CLHEP_VERSION.tgz
    if [ -d $CLHEP_VERSION/CLHEP ]; then
        ln -s $CLHEP_VERSION/CLHEP clhep
    fi
fi

mkdir $SIMPATH/tools/clhep-build
cd $SIMPATH/tools/clhep-build
cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL $SIMPATH/tools/clhep
make -j4 install
  
cd $SIMPATH
