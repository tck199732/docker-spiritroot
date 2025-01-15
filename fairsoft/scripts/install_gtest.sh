#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/gtest ]; then
    cd $SIMPATH/basics
    untar gtest $GTESTVERSION.tar.gz
    if [ -d googletest-$GTESTVERSION ]; then
        ln -s googletest-$GTESTVERSION gtest
    fi
fi

cd $SIMPATH/basics
cd gtest
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_C_COMPILER=$CC \
        ..
make
# fake the installation process
mkdir -p $SIMPATH_INSTALL/lib
cp libgtest.a libgtest_main.a $SIMPATH_INSTALL/lib
if [ ! -d $SIMPATH_INSTALL/include/gtest ]; then
    mkdir -p $SIMPATH_INSTALL/include
    cp -r ../include/gtest $SIMPATH_INSTALL/include
fi

cd $SIMPATH
