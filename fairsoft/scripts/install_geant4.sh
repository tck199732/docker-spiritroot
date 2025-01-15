#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

if [ ! -d $SIMPATH/transport/geant4 ]; then
    cd $SIMPATH/transport
    untar geant4 $GEANT4VERSION.tar.gz
    if [ -d $GEANT4VERSION ]; then
        ln -s $GEANT4VERSION geant4
    fi
fi

cd $SIMPATH/transport/geant4/

if [ -f ../${GEANT4VERSION}_c++11.patch ]; then
    mypatch ../${GEANT4VERSION}_c++11.patch
fi

mkdir -p build
cd build

install_data="-DGEANT4_INSTALL_DATA=ON"
geant4_cpp="-DGEANT4_BUILD_CXXSTD=c++11"
geant4_opengl="-DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_GDML=ON -DXERCESC_ROOT_DIR=$SIMPATH_INSTALL"

cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
            -DCMAKE_INSTALL_LIBDIR=$SIMPATH_INSTALL/lib \
            -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_CXX_COMPILER=$CXX \
            -DCMAKE_C_COMPILER=$CC \
            -DGEANT4_USE_G3TOG4=ON \
            -DGEANT4_BUILD_STORE_TRAJECTORY=OFF \
            -DGEANT4_BUILD_VERBOSE_CODE=ON \
            $geant4_opengl \
            $install_data $geant4_cpp ../

make -j4 install

mkdir -p $SIMPATH_INSTALL/bin

if [ ! -L $SIMPATH_INSTALL/share/Geant4 ]; then
    ln -s $SIMPATH_INSTALL/share/$GEANT4VERSIONp $SIMPATH_INSTALL/share/Geant4
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4ABLA ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4ABLA_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4ABLA
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4EMLOW ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4EMLOW_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4EMLOW
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4ENSDFSTATE ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4ENSDFSTATE_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4ENSDFSTATE
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4NDL ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4NDL_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4NDL
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4NEUTRONXS ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4NEUTRONXS_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4NEUTRONXS
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4PII ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4PII_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4PII
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/G4SAIDDATA ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${G4SAIDDATA_VERSION} $SIMPATH_INSTALL/share/Geant4/data/G4SAIDDATA
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/PhotonEvaporation ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${PhotonEvaporation_VERSION} $SIMPATH_INSTALL/share/Geant4/data/PhotonEvaporation
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/RadioactiveDecay ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${RadioactiveDecay_VERSION} $SIMPATH_INSTALL/share/Geant4/data/RadioactiveDecay
fi
if [ ! -L $SIMPATH_INSTALL/share/Geant4/data/RealSurface ]; then
    ln -s $SIMPATH_INSTALL/share/Geant4/data/${RealSurface_VERSION} $SIMPATH_INSTALL/share/Geant4/data/RealSurface
fi

. $SIMPATH_INSTALL/share/$GEANT4VERSIONp/geant4make/geant4make.sh

cd $SIMPATH
