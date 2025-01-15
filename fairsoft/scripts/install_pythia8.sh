#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/generators/pythia8 ]; then
    cd $SIMPATH/generators
    untar pythia8 $PYTHIA8VERSION.tgz
    if [ -d $PYTHIA8VERSION ]; then
        ln -s $PYTHIA8VERSION pythia8
    fi
fi

mkdir -p $SIMPATH_INSTALL/lib

cd $SIMPATH/generators/pythia8

USRLDFLAGSSHARED="$CXXFLAGS" ./configure --enable-shared --with-hepmc2=$HEPINSTALLDIR

make -j4 CFLAGS="$CFLAGS -m64" CXXFLAGS="$CXXFLAGS -m64"

mkdir -p $SIMPATH_INSTALL/include
cp -r include/Pythia8 $SIMPATH_INSTALL/include

mkdir -p $SIMPATH_INSTALL/share/pythia8
cp -r share/Pythia8/xmldoc $SIMPATH_INSTALL/share/pythia8
ln -s $SIMPATH_INSTALL/share/pythia8 $SIMPATH_INSTALL/share/Pythia8

cp lib/libpythia8.so $SIMPATH_INSTALL/lib

cd $SIMPATH
