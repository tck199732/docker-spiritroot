#!/bin/bash

tar zxf eigen-3.4.0.tar.gz
cd eigen-3.4.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install ..
make install
