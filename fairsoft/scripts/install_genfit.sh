#!/bin/bash

source scripts/functions.sh
source scripts/config.sh
source scripts/package_versions.sh
source scripts/spirit_packages.sh

if [ ! -d $SIMPATH/tools/GenFit ]; then
    cd $SIMPATH/tools
    if [ ! -e GenFit ]; then
        echo "*** Checking out GenFit sources ***"
        git clone $GENFIT2_LOCATION GenFit
    fi
fi

RAVEPATH=$SIMPATH_INSTALL/lib/pkgconfig
source $SIMPATH_INSTALL/bin/thisroot.sh

cd $SIMPATH/tools/GenFit

mypatch ../GenFit-CMakeLists.patch

mkdir build
cd build
RAVEPATH=$RAVEPATH BOOST_ROOT=$SIMPATH_INSTALL cmake ../ -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL -DBoost_NO_SYSTEM_PATHS=TRUE -DBoost_NO_BOOST_CMAKE=TRUE -DROOT_CONFIG_EXECUTABLE=$SIMPATH/install/bin/root-config
sed -i 's/\-I\ //' CMakeFiles/genfit2.dir/link.txt

make -j4
make -j4 install
  
cd  $SIMPATH
