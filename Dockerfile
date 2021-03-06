ARG base=debian:buster

## Install official Intel MKL repository for apt
## Commands below adapted from:
##     https://software.intel.com/en-us/articles/installing-intel-free-libs-and-python-apt-repo
##     https://github.com/eddelbuettel/mkl4deb
FROM nobodyxu/apt-fast:latest-debian-buster-slim AS install-mkl

# Install basic software for adding apt repository and downloading source code to compile
RUN apt-auto install -y --no-install-recommends apt-transport-https ca-certificates gnupg2 gnupg-agent \
                                                software-properties-common curl apt-utils

# Add key
RUN curl --progress-bar https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | apt-key add -
RUN echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list

# Install MKL
ARG year=2020
RUN apt-auto install -y '$(apt-cache search intel-mkl-$year | cut -d '-' -f 1,2,3,4  | tail -n 1)'

FROM $base AS configure-mkl
COPY --from=install-mkl /opt/intel/ /opt/intel/

## update alternatives
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 150

## Configure dynamic linker to use MKL
RUN echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf
RUN echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
RUN ldconfig

FROM $base AS final
COPY --from=configure-mkl / /

ENV MKL_THREADING_LAYER=GNU
