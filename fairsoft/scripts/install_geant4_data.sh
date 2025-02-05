#!/bin/bash

source scripts/functions.sh
source scripts/package_versions.sh
source scripts/config.sh
source $SIMPATH_INSTALL/bin/thisroot.sh

install_data=$SIMPATH_INSTALL/share/$GEANT4VERSIONp/data
data_source=$SIMPATH/transport

mkdir -p $install_data
if [ ! -L $SIMPATH_INSTALL/share/Geant4 ]; then
    ln -s $SIMPATH_INSTALL/share/$GEANT4VERSIONp $SIMPATH_INSTALL/share/Geant4
fi

echo "**** Installing the Geant4 data files ****"

cd $install_data

if [ ! -d $G4ABLA_VERSION ]; then
    if [ -e $data_source/$G4ABLA_TAR ]; then
        cp $data_source/$G4ABLA_TAR .
        untar G4ABLA $G4ABLA_TAR
        ln -s $G4ABLAVERSION G4ABLA
        rm $G4ABLA_TAR
    else
        echo "Could not find file $G4ABLA_TAR in $data_source"
    fi
else
    echo "Package $G4ABLA_VERSION already installed."
fi

if [ ! -d $G4EMLOW_VERSION ]; then
    if [ -e $data_source/$G4EMLOW_TAR ]; then
        cp $data_source/$G4EMLOW_TAR .
        untar G4EMLOW $G4EMLOW_TAR
        ln -s $G4EMLOW_VERSION G4EMLOW
        rm $G4EMLOW_TAR
    else
        echo "Could not find file $G4EMLOW_TAR in $data_source"
    fi
else
    echo "Package $G4EMLOW_VERSION already installed."
fi

if [ ! -d $G4ENSDFSTATE_VERSION ]; then
    if [ -e $data_source/$G4ENSDFSTATE_TAR ]; then
        cp $data_source/$G4ENSDFSTATE_TAR .
        untar G4ENSDFSTATE $G4ENSDFSTATE_TAR
        ln -s $G4ENSDFSTATEVERSION G4ENSDFSTATE
        rm $G4ENSDFSTATE_TAR
    else
        echo "Could not find file $G4ENSDFSTATE_TAR in $data_source"
    fi
else
    echo "Package $G4ENSDFSTATE_VERSION already installed."
fi

if [ ! -d $G4NDL_VERSION ]; then
    if [ -e $data_source/$G4NDL_TAR ]; then
        cp $data_source/$G4NDL_TAR .
        untar G4NDL $G4NDL_TAR
        ln -s $G4NDL_VERSION G4NDL
        rm $G4NDL_TAR
    else
        echo "Could not find file $G4NDL_TAR in $data_source"
    fi
else
    echo "Package $G4NDL_VERSION already installed."
fi

if [ ! -d $G4NEUTRONXS_VERSION ]; then
    if [ -e $data_source/$G4NEUTRONXS_TAR ]; then
        cp $data_source/$G4NEUTRONXS_TAR .
        untar G4NEUTRONXS $G4NEUTRONXS_TAR
        ln -s $G4NEUTRONXS_VERSION G4NEUTRONXS
        rm $G4NEUTRONXS_TAR
    else
        echo "Could not find file $G4NEUTRONXS_TAR in $data_source"
    fi
else
    echo "Package $G4NEUTRONXS_VERSION already installed."
fi

if [ ! -d $G4PII_VERSION ]; then
    if [ -e $data_source/$G4PII_TAR ]; then
        cp $data_source/$G4PII_TAR .
        untar G4PII $G4PII_TAR
        ln -s $G4PII_VERSION G4PII
        rm $G4PII_TAR
    else
        echo "Could not find file $G4PII_TAR in $data_source"
    fi
else
    echo "Package $G4PII_VERSION already installed."
fi

if [ ! -d $G4SAIDDATA_VERSION ]; then
    if [ -e $data_source/$G4SAIDDATA_TAR ]; then
        cp $data_source/$G4SAIDDATA_TAR .
        untar G4SAID $G4SAIDDATA_TAR
        ln -s $G4SAIDDATA_VERSION G4SAIDDATA
        rm $G4SAIDDATA_TAR
    else
        echo "Could not find file $G4SAIDDATA_TAR in $data_source"
    fi
else
    echo "Package $G4SAIDDATA_VERSION already installed."
fi

if [ ! -d $PhotonEvaporation_VERSION ]; then
    if [ -e $data_source/$PhotonEvaporation_TAR ]; then
        cp $data_source/$PhotonEvaporation_TAR .
        untar PhotonEvaporation $PhotonEvaporation_TAR
        ln -s $PhotonEvaporation_VERSION PhotonEvaporation
        rm $PhotonEvaporation_TAR
    else
        echo "Could not find file $PhotonEvaporation_TAR in $data_source"
    fi
else
    echo "Package $PhotonEvaporation_VERSION already installed."
fi

if [ ! -d $RadioactiveDecay_VERSION ]; then
    if [ -e $data_source/$RadioactiveDecay_TAR ]; then
        cp $data_source/$RadioactiveDecay_TAR .
        untar RadioactiveDecay $RadioactiveDecay_TAR
        ln -s $RadioactiveDecay_VERSION RadioactiveDecay
        rm $RadioactiveDecay_TAR
    else
        echo "Could not find file $RadioactiveDecay_VERSION in $data_source"
    fi
else
    echo "Package $RadioactiveDecay_VERSION already installed."
fi

if [ ! -d $RealSurface_VERSION ]; then
    if [ -e $data_source/$RealSurface_TAR ]; then
        cp $data_source/$RealSurface_TAR .
        untar RealSurface $RealSurface_TAR
        ln -s $RealSurface_VERSION RealSurface
        rm $RealSurface_TAR
    else
        echo "Could not find file $RealSurface_TAR in $data_source"
    fi
else
    echo "Package $RealSurface_VERSION already installed."
fi

cd $SIMPATH
