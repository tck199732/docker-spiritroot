
#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/generators/pythia6 ]; then
    cd $SIMPATH/generators
    untar pythia6 $PYTHIA6VERSION.tar.gz
fi

mkdir -p $SIMPATH_INSTALL/lib

cd $SIMPATH/generators/pythia6
cp ../CMakeLists.txt_pythia6 CMakeLists.txt
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_C_COMPILER=$CC \
    ..

make install


cd $SIMPATH
