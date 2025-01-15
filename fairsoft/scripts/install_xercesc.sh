#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/xercesc ]; then
    cd $SIMPATH/basics
    untar xercesc xerces-c-$XERCESCVERSION.tar.gz
    if [ -d xerces-c-$XERCESCVERSION ]; then
        ln -s xerces-c-$XERCESCVERSION xercesc
    fi
fi

cd $SIMPATH/basics/xercesc

LDFLAGS_BAK=$LDFLAGS
./configure --prefix=$SIMPATH_INSTALL
make -j4 install
LDFLAGS=$LDFLAGS_BAK

cd $SIMPATH
