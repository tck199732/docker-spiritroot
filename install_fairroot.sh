#!/bin/bash

if [ -z "$SIMPATH" ]; then
    echo "SIMPATH is not defined"
    exit 1
fi

if [ -z "$FAIRROOTPATH" ]; then
    echo "FAIRROOTPATH is not defined"
    exit 1
fi

tar zxf fairroot.tar.gz

cd fairroot
mkdir build 
cd build
cmake -DCMAKE_INSTALL_PREFIX=$FAIRROOTPATH \
      -DCMAKE_CXX_COMPILER=g++ \
      -DROOT_CONFIG_EXECUTABLE=$SIMPATH/bin/root-config \
      -DROOT_CINT_EXECUTABLE=$SIMPATH/bin/rootcint ..

make -j4
make install
