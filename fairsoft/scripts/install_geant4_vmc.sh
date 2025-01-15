#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

if [ ! -d  $SIMPATH/transport/geant4_vmc ]; then
    cd $SIMPATH/transport
    untar geant4_vmc geant4_vmc.$GEANT4VMCBRANCH.tar.gz
fi

cd $SIMPATH/transport/geant4_vmc

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
            -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_CXX_COMPILER=$CXX \
            -DCMAKE_C_COMPILER=$CC \
            -DGeant4VMC_USE_VGM=ON \
            -DGeant4VMC_USE_GEANT4_UI=Off \
            -DGeant4VMC_USE_GEANT4_VIS=Off \
            -DGeant4VMC_USE_GEANT4_G3TOG4=On \
            -DGeant4_DIR=$SIMPATH_INSTALL \
            -DROOT_DIR=$SIMPATH_INSTALL \
            -DVGM_DIR=$SIMPATH_INSTALL/lib/$VGMDIR \
            ..

make install -j4

cd $SIMPATH_INSTALL
mkdir -p share/geant4_vmc
ln -s $SIMPATH_INSTALL/share/Geant4VMC-3.3.0/examples/macro $SIMPATH_INSTALL/share/geant4_vmc/macro

cd $SIMPATH
