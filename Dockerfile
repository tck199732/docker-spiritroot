
FROM rockylinux:8.8 AS base
ENV LANG=en_US.UTF-8

WORKDIR /root
COPY packages.txt /root/

RUN yum -y update && \
    yum -y install $(cat /root/packages.txt) && \
    yum clean all

# Stage 2a : Configure FairSoft
# --------------------------------------------------------------------------
FROM base AS fairsoft-configure
COPY ./fairsoft /root/fairsoft
WORKDIR /root/fairsoft
ENV SIMPATH=/root/fairsoft \
    SIMPATH_INSTALL=/root/fairsoft/install

RUN scripts/check_system.sh

# Stage 2b: Build FairSoft-basics
# --------------------------------------------------------------------------
FROM base AS fairsoft-basics

COPY --from=fairsoft-configure /root/fairsoft /root/fairsoft
WORKDIR /root/fairsoft
ENV SIMPATH=/root/fairsoft \
    SIMPATH_INSTALL=/root/fairsoft/install

RUN scripts/install_gtest.sh && \
    scripts/install_gsl.sh && \
    scripts/install_boost.sh && \
    scripts/install_nanomsg.sh && \
    scripts/install_xercesc.sh && \
    scripts/install_millepede.sh && \
    scripts/install_zeromq.sh && \
    scripts/install_protobuf.sh && \
    scripts/install_flatbuffers.sh && \
    scripts/install_msgpack.sh && \
    rm -rf $SIMPATH/basics

# Stage 2c: Build FairSoft-generators
# --------------------------------------------------------------------------
FROM fairsoft-basics AS fairsoft-generators

COPY --from=fairsoft-basics /root/fairsoft /root/fairsoft
WORKDIR /root/fairsoft
ENV SIMPATH=/root/fairsoft \
    SIMPATH_INSTALL=/root/fairsoft/install

RUN scripts/install_pythia6.sh && \
    scripts/install_hepmc.sh && \
    scripts/install_pythia8.sh && \
    rm -rf $SIMPATH/generators

# Stage 2d: Build FairSoft-tools
# --------------------------------------------------------------------------
FROM fairsoft-generators AS fairsoft-tools

COPY --from=fairsoft-generators /root/fairsoft /root/fairsoft
WORKDIR /root/fairsoft
ENV SIMPATH=/root/fairsoft \
    SIMPATH_INSTALL=/root/fairsoft/install

RUN scripts/install_root6.sh && \
    scripts/install_clhep.sh && \
    scripts/install_rave.sh && \
    scripts/install_genfit.sh && \
    scripts/install_anaroot.sh && \
    rm -rf $SIMPATH/tools

# Stage 2e: Build FairSoft-transport
# --------------------------------------------------------------------------
FROM fairsoft-tools AS fairsoft-transport

COPY --from=fairsoft-tools /root/fairsoft /root/fairsoft
WORKDIR /root/fairsoft
ENV SIMPATH=/root/fairsoft \
    SIMPATH_INSTALL=/root/fairsoft/install

RUN scripts/install_geant3.sh && \
    scripts/install_geant4.sh && \
    scripts/install_geant4_data.sh && \
    scripts/install_g4py.sh && \
    scripts/install_vgm.sh && \
    scripts/install_geant4_vmc.sh && \
    rm -rf $SIMPATH/transport && \
    rm -rf $SIMPATH/scripts
   
# Stage 3: Build FairRoot
# --------------------------------------------------------------------------
FROM fairsoft-transport AS fairroot

COPY --from=fairsoft-transport /root/fairsoft/install /root/fairsoft/install

ENV SIMPATH=/root/fairsoft/install
ENV PATH=$SIMPATH/bin:$PATH
ENV LD_LIBRARY_PATH=$SIMPATH/lib:$LD_LIBRARY_PATH

WORKDIR /root
COPY fairroot.tar.gz install_fairroot.sh /root/
ENV FAIRROOTPATH=/root/fairroot/install
RUN ./install_fairroot.sh

# Stage 4: Build eigen-3.4.0
# --------------------------------------------------------------------------
FROM base AS eigen3

WORKDIR /root
COPY eigen-3.4.0.tar.gz install_eigen3.sh /root/
RUN ./install_eigen3.sh
    
# Stage 5: Final image
# --------------------------------------------------------------------------
FROM fairroot AS final

COPY --from=fairroot /root/fairsoft/install /root/fairsoft/install
COPY --from=fairroot /root/fairroot/install /root/fairroot/install
COPY --from=eigen3 /root/eigen-3.4.0 /root/eigen-3.4.0

ENV SIMPATH=/root/fairsoft/install
ENV FAIRROOTPATH=/root/fairroot/install
ENV MANPATH=$SIMPATH/share
ENV PATH=$SIMPATH/bin:$FAIRROOTPATH/bin:$PATH
ENV Eigen3_DIR=/root/eigen-3.4.0/build
ENV LD_LIBRARY_PATH=${SIMPATH}/lib:$FAIRROOTPATH/lib:$LD_LIBRARY_PATH
WORKDIR /root

CMD ["/bin/bash", "-c", "source $SIMPATH/share/Geant4/geant4make/geant4make.sh && source $SIMPATH/bin/thisroot.sh && exec /bin/bash"]




