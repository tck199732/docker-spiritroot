#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/basics/boost ]; then
    cd $SIMPATH/basics
    untar boost $BOOSTVERSION.tar.bz2
    if [ -d $BOOSTVERSION ]; then
        ln -s $BOOSTVERSION boost
    fi
fi

cd $SIMPATH/basics/boost

_icu_path=""

toolset=gcc

cxxflags="-std=c++11"
if [ $haslibcxx ]; then
    cxxflags="$cxxflags -stdlib=libc++"
fi
./bootstrap.sh cxxflags="$cxxflags" linkflags="$cxxflags" --with-toolset=$toolset --with-python=$(which python2)
./b2 ${_icu_path} cxxflags="$cxxflags" linkflags="$cxxflags" --build-dir=$PWD/tmp --build-type=minimal --toolset=$toolset --prefix=$SIMPATH_INSTALL --layout=system -j 4 install

python_version=$(python2 --version 2>&1 | awk '{split($2, ver, "."); print ver[1]ver[2]}')
ln -s $SIMPATH_INSTALL/lib/libboost_python${python_version}.so $SIMPATH_INSTALL/lib/libboost_python.so
ln -s $SIMPATH_INSTALL/lib/libboost_python${python_version}.a $SIMPATH_INSTALL/lib/libboost_python.a

cd $SIMPATH
