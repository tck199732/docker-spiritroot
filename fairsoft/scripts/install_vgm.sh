#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

CXXFLAGS_BAK=$CXXFLAGS
CXXFLAGS="$CXXFLAGS -m64"
CFLAGS_BAK=$CFLAGS
CFLAGS="$CFLAGS -m64"
export CXXFLAGS
export CFLAGS

if [ ! -d $SIMPATH/transport/vgm ]; then
    cd $SIMPATH/transport
    if [ ! -d vgm ]; then
        untar vgm vgm.$VGMVERSION.tar.gz
        if [ -d vgm.$VGMVERSION ]; then
            ln -s vgm.$VGMVERSION vgm
        fi
    fi
fi

cd $SIMPATH/transport/vgm

mkdir build_cmake
cd build_cmake

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_C_COMPILER=$CC \
    -DGeant4_DIR=$SIMPATH_INSTALL/lib/$GEANT4VERSIONp \
    -DROOT_DIR=$SIMPATH_INSTALL \
    -DWITH_TEST=OFF \
    ..

make install -j4

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SIMPATH_INSTALL/lib
export USE_VGM=1
export VGM_INSTALL=$SIMPATH_INSTALL

CXXFLAGS=$CXXFLAGS_BAK
CFLAGS=$CFLAGS_BAK
export CXXFLAGS
export CFLAGS

cd $SIMPATH

