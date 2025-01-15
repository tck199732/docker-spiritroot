#!/bin/bash

# ENV needed in some installation script. Values are taken from output of `check_system.sh`

export CXX=g++
export CC=gcc
export FC=gfortran
export F77=$FC
export CFLAGS="-O3"
export FFLAGS=$CFLAGS
export CXXFLAGS="-O3 -std=c++11"
export BUILD_TYPE="Release"

# System              :  64bit
# C++ compiler        :  g++
# C compiler          :  gcc
# Fortran compiler    :  gfortran
# CXXFLAGS            :  -O3 -std=c++11
# CFLAGS              :  -O3
# FFLAGS              :  -O3
# CMAKE BUILD TYPE    :  Release
# Compiler            :  gcc
# Fortran compiler    :  gfortran
# Debug               :  no
# Optimization        :  yes
# Platform            :  linux
# Architecture        :  linuxx8664gcc
# Number of parallel processes for build :  4