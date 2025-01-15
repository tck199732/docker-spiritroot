#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/MillepedeII ]; then
    cd $SIMPATH/basics
    if [ ! -d MillepedeII ]; then
        untar MillepedeII MillepedeII.tar.gz
    fi
fi

cd $SIMPATH/basics/MillepedeII
mypatch ../Makefile_millepede.patch
make

mkdir -p $SIMPATH_INSTALL/bin
cp $SIMPATH/basics/MillepedeII/pede $SIMPATH_INSTALL/bin

cp ../CMakeLists.txt_libMille CMakeLists.txt
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_C_COMPILER=$CC \
        ..
make install


cd $SIMPATH
