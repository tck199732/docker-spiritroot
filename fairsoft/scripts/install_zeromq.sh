#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/zeromq ]; then
    cd $SIMPATH/basics
    untar zeromq zeromq-$ZEROMQVERSION.tar.gz
    if [ -d zeromq-$ZEROMQDIR ]; then
        ln -s zeromq-$ZEROMQDIR zeromq
    fi
fi

cd $SIMPATH/basics/zeromq

distribution=$(lsb_release -is)
version=$(lsb_release -rs | cut -f1 -d.)     

PKG_CONFIG_PATH=$SIMPATH_INSTALL/lib/pkgconfig ./configure --prefix=$SIMPATH_INSTALL --libdir=$SIMPATH_INSTALL/lib --enable-static --without-libsodium
make
make install

cd $SIMPATH
