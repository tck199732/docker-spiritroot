#!/bin/bash
source scripts/functions.sh

default_lang=$(echo $LANG)
LANG=en_EN.utf-8

# platform=linux
# PLATFORM=$platform
# system=64bit
# checklib64="yes"

export CXX=g++
export CC=gcc
export CFLAGS="-O3"

# needed in Test_CMakeLists.txt, only needed in this test build
export Fortran_Needed=TRUE
export Root_Version=6
export BUILD_BATCH=FALSE
export BUILD_PYTHON=TRUE

mkdir -p $SIMPATH/test/build
cd $SIMPATH/test

cp $SIMPATH/scripts/FairVersion.h.* .
cp $SIMPATH/scripts/GenerateVersionInfo.cmake .
cp $SIMPATH/scripts/Test_CMakeLists.txt CMakeLists.txt
cp $SIMPATH/scripts/configure.in .

cd build
cmake .. -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_C_COMPILER=$CC

hascxx11=$(grep HasCxx11 $SIMPATH/test/configure | cut -f2 -d:)
haslibcxx=$(grep HasLibCxx $SIMPATH/test/configure | cut -f2 -d:)
_hascurl=$(grep HasCurl $SIMPATH/test/configure | cut -f2 -d:)
isMacOsx108=$(grep isMacOsx108 $SIMPATH/test/configure | cut -f2 -d:)

if [ ${_hascurl} ]; then
    install_curl=no
else
    install_curl=yes
fi

export CXXFLAGS="${CFLAGS}"

if [ $hascxx11 ]; then
    export CXXFLAGS="${CXXFLAGS} -std=c++11"
    export build_cpp11=yes
fi

if [ $haslibcxx ]; then
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++"
fi

export isMacOsx108

export FC=$(grep FortranCompiler $SIMPATH/test/configure | cut -f2 -d:)
if [ "$FC" = "f95" ]; then
    export FC=$(readlink -f `which f95`)
fi
export F77=$FC
export FFLAGS=${CFLAGS}
export LANG=${default_lang}

# Define the corresponding CMake build type
if [[ $CXXFLAGS == *"-g"* ]]; then
    if [[ $CXXFLAGS == *"O0"* ]]; then
        export BUILD_TYPE=Debug
    else
        export BUILD_TYPE=RelWithDebInfo
    fi
else
    export BUILD_TYPE=Release
fi

cd $SIMPATH
rm -rf test

echo "C++ compiler        : " $CXX
echo "C compiler          : " $CC
echo "Fortran compiler    : " $FC
echo "CXXFLAGS            : " $CXXFLAGS
echo "CFLAGS              : " $CFLAGS
echo "FFLAGS              : " $FFLAGS
echo "CMAKE BUILD TYPE    : " $BUILD_TYPE
