#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/msgpack ]; then
    cd $SIMPATH/basics
    untar msgpack msgpack.$MSGPACK_BRANCH.tar.gz
fi

cd $SIMPATH/basics/msgpack

mkdir -p build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_C_COMPILER=$CC \
        -DMSGPACK_CXX11=ON \
        -DMSGPACK_BUILD_TESTS=OFF \
        ..

make -j4

make install

cd $SIMPATH
