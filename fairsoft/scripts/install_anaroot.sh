#!/bin/bash

source scripts/functions.sh
source scripts/config.sh
source scripts/package_versions.sh
source scripts/spirit_packages.sh

if [ ! -d $SIMPATH/tools/anaroot ]; then
    cd $SIMPATH/tools
    if [ ! -d anaroot ]; then
        echo "*** Checking out anaroot sources ***"
        git clone -b $ANAROOT_VERSION $ANAROOT_LOCATION
    fi
fi

source $SIMPATH_INSTALL/bin/thisroot.sh
cd $SIMPATH/tools/anaroot/
ROOTSYS=$SIMPATH_INSTALL ./autogen.sh --prefix=$SIMPATH_INSTALL


make -j4
make -j4 install
  
cd  $SIMPATH
