#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/nanomsg ]; then
    cd $SIMPATH/basics
    untar nanomsg $NANOMSG_VERSION.tar.gz
    if [ -d $NANOMSG_VERSION ]; then
        ln -s $NANOMSG_VERSION nanomsg
    fi
fi

cd $SIMPATH/basics/nanomsg
./configure --prefix=$SIMPATH_INSTALL
make -j4
make install

cd $SIMPATH
