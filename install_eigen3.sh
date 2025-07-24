#!/bin/bash

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
tar zxf eigen-3.4.0.tar.gz
cd eigen-3.4.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install ..
make install
