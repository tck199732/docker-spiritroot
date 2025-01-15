#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/gsl ]; then
    cd $SIMPATH/basics
    untar gsl $GSLVERSION.tar.gz
    if [ -d $GSLVERSION ]; then
        ln -s $GSLVERSION gsl
    fi
fi


CXXFLAGS_BAK=$CXXFLAGS
CXXFLAGS="$CXXFLAGS -m64"
export CXXFLAGS
CFLAGS_BAK=$CFLAGS
CFLAGS="$CFLAGS -m64"
export CFLAGS

cd $SIMPATH/basics/gsl
./configure --prefix=$SIMPATH_INSTALL --with-pic --libdir=$SIMPATH_INSTALL/lib
make -j4
make install -j4

CXXFLAGS=$CXXFLAGS_BAK
CFLAGS=$CFLAGS_BAK
export CXXFLAGS
export CFLAGS

cd $SIMPATH
