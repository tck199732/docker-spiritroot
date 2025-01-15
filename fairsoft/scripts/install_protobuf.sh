#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/protobuf ]; then
    cd $SIMPATH/basics
    untar protobuf $PROTOBUF_VERSION.tar.gz
    if [ -d $PROTOBUF_VERSION ]; then
        ln -s $PROTOBUF_VERSION protobuf
    fi
fi

cd $SIMPATH/basics/protobuf
./configure --prefix=$SIMPATH_INSTALL
make -j4
make install
unset LIBS

cd $SIMPATH

