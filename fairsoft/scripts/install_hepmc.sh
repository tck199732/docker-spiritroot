#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/generators/HepMC ]; then
    cd $SIMPATH/generators
    untar hepmc HepMC-$HEPMCVERSION.tar.gz
    if [ -d HepMC-$HEPMCVERSION ]; then
        ln -s HepMC-$HEPMCVERSION HepMC
    fi
fi


mkdir -p $SIMPATH_INSTALL/lib

cd $SIMPATH/generators

mkdir build_HepMC
cd build_HepMC

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
            -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_CXX_COMPILER=$CXX \
            -DCMAKE_C_COMPILER=$CC \
            -Dmomentum:STRING=GEV \
            -Dlength:STRING=CM \
            ../HepMC

make install -j4

export HEPINSTALLDIR=$SIMPATH_INSTALL

cd $SIMPATH
