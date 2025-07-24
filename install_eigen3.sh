#!/bin/bash

if [ -z "${LD_LIBRARY_PATH:-}" ]; then
    export LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64"
else
    export LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH"
fi
tar zxf eigen-3.4.0.tar.gz
cd eigen-3.4.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install ..
make install
