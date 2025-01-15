#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/flatbuffers ]; then
    cd $SIMPATH/basics
    untar flatbuffers flatbuffers.$FLATBUFFERS_BRANCH.tar.gz
fi

cd $SIMPATH/basics/flatbuffers
sed -i "s/-Werror=shadow//g" CMakeLists.txt

mkdir -p build
cd build
cmake -G "Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_C_COMPILER=$CC \
        ..

make -j4

make install

cd $SIMPATH

