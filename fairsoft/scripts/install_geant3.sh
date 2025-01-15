#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

if [ ! -d $SIMPATH/transport/geant3 ]; then
    cd $SIMPATH/transport
    git clone $GEANT3_LOCATION
    cd $SIMPATH/transport/geant3
    git checkout -b $GEANT3BRANCH $GEANT3BRANCH
fi

mkdir -p $SIMPATH_INSTALL/include/TGeant3

cd $SIMPATH/transport
cp gdecay.F geant3/gphys
cp gdalet.F geant3/gphys
cp gdalitzcbm.F geant3/gphys

cd geant3

cmake_list=cmake/Geant3BuildLibrary.cmake
search_str='set(CMAKE_Fortran_FLAGS "\${CMAKE_Fortran_FLAGS} -finit-local-zero -fno-strict-overflow")'
replace_str='set(CMAKE_Fortran_FLAGS "\${CMAKE_Fortran_FLAGS} -finit-local-zero -fno-strict-overflow -std=legacy")'
sed -i "s|$search_str|$replace_str|g" $cmake_list

mkdir gcalor
cjp ../gcalor.F gcalor
rm added/dummies_gcalor.c

# patches needed to compile gcalor and for changes in geane
mypatch ../geant3_geane.patch
mypatch ../Geant3_CMake.patch
mypatch ../geant3_structs.patch

if [ ! -f data/xsneut.dat ]; then
    cp ../xsneut.dat.bz2 data
    bunzip2 data/xsneut.dat.bz2
fi
cp ../chetc.dat data

mypatch ../geant3_root6.patch

mypatch ../Geant3_32bit.patch

mkdir build
cd build

echo "installing to $SIMPATH_INSTALL"

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
            -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_CXX_COMPILER=$CXX \
            -DCMAKE_C_COMPILER=$CC \
            -DROOT_DIR=$SIMPATH_INSTALL \
            ..

make install -j4


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SIMPATH_INSTALL

cd $SIMPATH
