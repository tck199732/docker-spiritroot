#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh

if [ ! -d $SIMPATH/tools/root ]; then
    cd $SIMPATH/tools
    git clone --depth 1 --branch $ROOTVERSION $ROOT_LOCATION
fi

CXXFLAGS_BAK=$CXXFLAGS
CXXFLAGS="$CFLAGS"
export CXXFLAGS

libdir=$SIMPATH_INSTALL/lib/root
_build_xrootd=no

if [ "${_build_xrootd}" = "yes" ]; then
    if (not_there xrootd $SIMPATH_INSTALL/bin/xrd); then
        cd $SIMPATH/tools/root
    fi  
fi

cd $SIMPATH/tools/root
mkdir build_for_fair

cp ../rootconfig.sh build_for_fair/
echo "Copied rootconfig.sh ......................"
echo "Configure Root .........................................."

# needed to solve problem with the TGeoManager for some CBM and Panda geometries
mypatch ../root_TGeoShape.patch


cd build_for_fair/
. rootconfig.sh

make -j4

cd $SIMPATH/tools/root/etc/vmc

cp Makefile.linuxx8664gcc Makefile.linuxx8664icc
mysed 'g++' 'icpc' Makefile.linuxx8664icc
mysed 'g77' 'ifort' Makefile.linuxx8664icc
mysed 'gcc' 'icc' Makefile.linuxx8664icc
mysed 'SHLIB         = -lg2c' '' Makefile.linuxx8664icc
mysed '-fno-f2c -fPIC' '-fPIC' Makefile.linuxx8664icc
mysed '-fno-second-underscore' '' Makefile.linuxx8664icc

if [[ $FC =~ .*gfortran.* ]]; then
    arch=linuxx8664icc
    mysed "OPT   = -O2 -g" "OPT   = ${CXXFLAGS}" Makefile.$arch
    mysed 'LDFLAGS       = $(OPT)' "LDFLAGS       = ${CXXFLAGS_BAK}" Makefile.$arch
fi

cd $SIMPATH/tools/root/build_for_fair/

make install


#### Workaround for VC and AliRoot ###
echo " create a symbolic linking for Vc library .... "
if [ -e $SIMPATH_INSTALL/lib/libVc.a ]; then
    cd $SIMPATH_INSTALL/lib/root
    ln -s ../libVc.a
    echo "---link created --- "
else
    echo "libVc.a not found in lib directory "
fi
#####################################

export PATH=${SIMPATH_INSTALL}/bin:${PATH}
export LD_LIBRARY_PATH=${libdir}:${LD_LIBRARY_PATH}

CXXFLAGS=$CXXFLAGS_BAK
export CXXFLAGS

cd $SIMPATH
