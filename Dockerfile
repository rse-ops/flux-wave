ARG tag=focal
FROM ubuntu:${tag}

# docker build ghcr.io/rse-ops/flux-wave:latest .

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/
RUN apt-get update && \
    apt-get install -y fftw3-dev \
    fftw3 \
    pdsh \
    libfabric-dev \
    libfabric1 \
    git \
    libmpich-dev \
    mpich \
    cmake \
    g++

# install laamps
RUN git clone --depth 1 --branch stable_29Sep2021_update2 https://github.com/lammps/lammps.git /opt/lammps && \
    cd /opt/lammps && \
    mkdir build && \
    cd build && \
    . /etc/profile && \ 
    cmake ../cmake -D PKG_REAXFF=yes -D BUILD_MPI=yes -D PKG_OPT=yes -D FFT=FFTW3 && \
    make -j ${build_jobs} && \
    make install

# Create a home to put the examples in, and
# ensure lmp executable is on path for flux user
# And anyone can interact with lammps examples
RUN useradd -ms /bin/bash -u 1234 flux && \
    mv /opt/lammps/examples /home/flux/examples && \
    chown -R 1234 /home/flux/examples && \
    cp /root/.local/bin/lmp /usr/local/bin/lmp
    
# Target this example
ENV PATH=/root/.local/bin:$PATH
WORKDIR /home/flux/examples/reaxff/HNS
