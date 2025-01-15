#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

cd $SIMPATH/transport/geant4/environments/g4py
mypatch ../../../g4py.patch

cd $SIMPATH/transport/geant4
mkdir build_g4py
cd build_g4py

cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DPYTHON_EXECUTABLE=$(which python2) \
        -DXERCESC_ROOT_DIR=${SIMPATH_INSTALL}  \
        -DBOOST_ROOT=${SIMPATH_INSTALL} \
        -DBoost_NO_SYSTEM_PATHS=TRUE \
        -DBoost_NO_BOOST_CMAKE=TRUE \
        ../environments/g4py

make -j4
make install -j4

cd $SIMPATH

