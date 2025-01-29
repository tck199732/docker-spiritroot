
FROM rockylinux:8.8 AS base
ENV LANG=en_US.UTF-8

WORKDIR /app
COPY packages.txt /app/

RUN yum -y update && \
    yum -y install $(cat /app/packages.txt) && \
    yum clean all

# Stage 2a : Configure FairSoft
# --------------------------------------------------------------------------
FROM base AS fairsoft-configure

COPY ./fairsoft /app/fairsoft
WORKDIR /app/fairsoft
ENV SIMPATH=/app/fairsoft \
    SIMPATH_INSTALL=/app/fairsoft/install

RUN scripts/check_system.sh

# Stage 2b: Build FairSoft-basics
# --------------------------------------------------------------------------
FROM base AS fairsoft-basics

COPY --from=fairsoft-configure /app/fairsoft /app/fairsoft
WORKDIR /app/fairsoft
ENV SIMPATH=/app/fairsoft \
    SIMPATH_INSTALL=/app/fairsoft/install

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

COPY --from=fairsoft-basics /app/fairsoft /app/fairsoft
WORKDIR /app/fairsoft
ENV SIMPATH=/app/fairsoft \
    SIMPATH_INSTALL=/app/fairsoft/install

RUN scripts/install_pythia6.sh && \
    scripts/install_hepmc.sh && \
    scripts/install_pythia8.sh && \
    rm -rf $SIMPATH/generators

# Stage 2d: Build FairSoft-tools
# --------------------------------------------------------------------------
FROM fairsoft-generators AS fairsoft-tools

COPY --from=fairsoft-generators /app/fairsoft /app/fairsoft
WORKDIR /app/fairsoft
ENV SIMPATH=/app/fairsoft \
    SIMPATH_INSTALL=/app/fairsoft/install

RUN scripts/install_root6.sh && \
    scripts/install_clhep.sh && \
    scripts/install_rave.sh && \
    scripts/install_genfit.sh && \
    scripts/install_anaroot.sh && \
    rm -rf $SIMPATH/tools

# Stage 2e: Build FairSoft-transport
# --------------------------------------------------------------------------
FROM fairsoft-tools AS fairsoft-transport

COPY --from=fairsoft-tools /app/fairsoft /app/fairsoft
WORKDIR /app/fairsoft
ENV SIMPATH=/app/fairsoft \
    SIMPATH_INSTALL=/app/fairsoft/install

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

COPY --from=fairsoft-transport /app/fairsoft/install /app/fairsoft/install

ENV SIMPATH=/app/fairsoft/install
ENV PATH=$SIMPATH/bin:$PATH
ENV LD_LIBRARY_PATH=$SIMPATH/lib:$LD_LIBRARY_PATH

WORKDIR /app
COPY fairroot.tar.gz install_fairroot.sh /app/
ENV FAIRROOTPATH=/app/fairroot/install
RUN ./install_fairroot.sh

# Stage 4: Build eigen-3.4.0
# --------------------------------------------------------------------------
FROM base AS eigen3

WORKDIR /app
COPY eigen-3.4.0.tar.gz install_eigen3.sh /app/
RUN ./install_eigen3.sh
    
# Stage 5: Final image
# --------------------------------------------------------------------------
FROM fairroot AS final

COPY --from=fairroot /app/fairsoft/install /app/fairsoft/install
COPY --from=fairroot /app/fairroot/install /app/fairroot/install
COPY --from=eigen3 /app/eigen-3.4.0 /app/eigen-3.4.0

RUN chown -R root:root /app/fairsoft/install && \
    chown -R root:root /app/fairroot/install && \
    chown -R root:root /app/eigen-3.4.0 && \
    chmod -R 755 /app/fairsoft/install && \
    chmod -R 755 /app/fairroot/install && \
    chmod -R 755 /app/eigen-3.4.0

ENV SIMPATH=/app/fairsoft/install
ENV FAIRROOTPATH=/app/fairroot/install
ENV MANPATH=$SIMPATH/share
ENV PATH=$SIMPATH/bin:$FAIRROOTPATH/bin:$PATH
ENV Eigen3_DIR=/app/eigen-3.4.0/build
ENV LD_LIBRARY_PATH=${SIMPATH}/lib:${SIMPATH}/lib64:$FAIRROOTPATH/lib:$LD_LIBRARY_PATH

WORKDIR /app

CMD ["/bin/bash", "-c", "source $SIMPATH/share/Geant4/geant4make/geant4make.sh && source $SIMPATH/bin/thisroot.sh && exec /bin/bash"]




