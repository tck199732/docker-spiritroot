#!/bin/bash

source scripts/functions.sh
source scripts/config.sh
source scripts/package_versions.sh
source scripts/spirit_packages.sh

if [ ! -d $SIMPATH/tools/rave ]; then
    cd $SIMPATH/tools
    if [ ! -e rave ]; then
        echo "*** Checking out rave sources ***"
        git clone -b $RAVE_VERSION $RAVE_LOCATION rave
    fi
fi

clhep_exe=$SIMPATH_INSTALL

source $SIMPATH/scripts/install_autoconf.sh
source $SIMPATH/scripts/install_automake.sh
source $SIMPATH/scripts/install_libtool.sh
cd $SIMPATH/tools/rave/

# run autoreconf to avoid `missing aclocal`, see https://github.com/ivmai/cudd/issues/2
autoreconf
./configure --prefix=$SIMPATH_INSTALL \
            --disable-java \
            --with-clhep=$SIMPATH_INSTALL \
            --with-boost=$SIMPATH_INSTALL \
            --with-boost-libdir=$SIMPATH_INSTALL/lib

make -j4
make -j4 install

cd $SIMPATH
