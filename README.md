# docker-spiritroot

This repository provides a Docker image for compiling a specific branch of [**`SpiRITROOT--2024Spring`**](https://github.com/SpiRIT-Collaboration/SpiRITROOT/tree/2024Spring), used in the SpiRIT TPC experiment at RIKEN.

Due to the incompatibility of several outdated dependencies, installing these on modern Linux distributions such as Ubuntu 22.04 or 24.04 is challenging. This Docker image replicates the working setup from Hokusai HPC at RIKEN, starting with a base image of [RockyLinux 8.8](https://hub.docker.com/layers/library/rockylinux/8.8/images/sha256-20cfffabbe5fe1ff6643741bde0afdea23a2e525639b2fbf97c5820ecad11871).

## Content
* [**1. Pre-requiste**](#prerequiste)
* [**2. Usage**](#usage-docker)
* [**3. Usage**](#usage-singularity)


## Prerequiste
Before using this repository, ensure you have the following:
- [`Docker`](https://docs.docker.com/get-started/get-docker/), if you have root privileges.
- **[Optional]** Singularity, typically pre-installed on HPC systems as an alternative to Docker

- Clone the SpiRITROOT repository:
```
git clone -b 2024Spring https://github.com/SpiRIT-Collaboration/SpiRITROOT
```

## Usage (Docker)
### 1. pull the docker image, see [here](https://hub.docker.com/r/tck199732/spiritroot)
```{bash}
docker pull tck199732/:latest
```
### 2. run the container 
```
docker run -it -v ${host_dir}:${container_dir} tck199732/spirit-root
```
- Replace `${host_dir}` with the path to the SpiRITROOT directory on your machine.
- Replace `${container_dir}` with the desired mount point inside the container (e.g., `/root/SpiRITROOT`).

### 3. Compile SpiRITROOT
- Optional] Compilating `SpiRITROOT` generates a file `VERSION.compiled` which indicates the compiled version of `SpiRITROOT` formatted according to git commits and branch being used. To access these information, one must navigate to the `${container_dir}` and run 
```
git config --global --add safe.directory $(pwd)
```

- Navigate to the mounted directory in the container:
```{bash}
# in the SpiRITROOT directory 
mkdir -p build
cd build
cmake .. -DCMAKE_CXX_COMPILER=g++ \
 -DROOT_CONFIG_EXECUTABLE=${SIMPATH}/bin/root-config \
 -DROOT_CINT_EXECUTABLE=${SIMPATH}/bin/rootcint \
 -DEigen3_DIR=$Eigen3_DIR
make -j4
```
### 4. Verify Compilation
- Source the `config.sh` file 
```
source config.sh
```
Expected output:
```{bash}
[root@e79fa05ae8ee build]# . config.sh 
System during compilation: Rocky Linux release 8.10 (Green Obsidian)
                           x86_64
System now               : Rocky Linux release 8.10 (Green Obsidian)
                           x86_64
[root@e79fa05ae8ee build]# 
```

### 5. Post-Execution
- Exit the container and restore file ownership:
```
chown -R ${USER}:${USER} SpiRITROOT
```

## Singularity - for users without sudo privilege
It is hard to use Docker without root privileges, especially on HPC. Instead, (Singularity)[https://sylabs.io/singularity/] users an alternative way to use Docker images⁠. To check if singularity command is available, do the following: 
```{bash}
user@server $ singularity --version
singularity-ce version 3.11.4-1.el8
```
1. build the singularity image file
```
user@server $ singularity build image.sif docker://tck199732/spiritroot
INFO:    Starting build...
Getting image source signatures
...
INFO:    Creating SIF file...
INFO:    Build complete: image.sif
```
This process usually takes a few minutes. You will probably see a lot of warning message `warn rootless{opt/root/lib/libASImage.so} ignoring (usually) harmless EPERM on setxattr "user.rootlesscontainers` but it probably does not affect its functionality. An file named `image.sif` is now generated. 

2. Compile SpiRIROOT with singularity image
Unlike Docker images, singularity mounts the host system to the container and retains the user privileges. To compile `SpiRIROOT`, prepare a script for the procedures, i.e.
```
#!/bin/bash
# compile.sh
mkdir -p build
cd build
cmake .. -DCMAKE_CXX_COMPILER=g++ \
 -DROOT_CONFIG_EXECUTABLE=${SIMPATH}/bin/root-config \
 -DROOT_CINT_EXECUTABLE=${SIMPATH}/bin/rootcint \
 -DEigen3_DIR=$Eigen3_DIR
make -j4
cd ..
```
and make it an executable and finally run it with singularity
```
chmod +x ./compile.sh
singularity exec image.sif ./compile.sh
```
