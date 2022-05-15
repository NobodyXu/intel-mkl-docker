ARG base=debian:buster

## Install official Intel MKL repository for apt
## Commands below adapted from:
##     https://software.intel.com/en-us/articles/installing-intel-free-libs-and-python-apt-repo
##     https://github.com/eddelbuettel/mkl4deb
FROM debian:stable-slim AS install-mkl

ENV DEBIAN_FRONTEND=noninteractive

# Install basic software for adding apt repository and downloading source code to compile
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg2 gnupg-agent \
                                               software-properties-common curl apt-utils

# Add key
ENV BASE_URL=https://apt.repos.intel.com
ENV GPG_URL=$BASE_URL/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
ENV GPG_FILE=/usr/share/keyrings/intel-gpg-archive-keyring.gpg

RUN curl $GPG_URL | gpg --dearmor > $GPG_FILE
RUN echo "deb [signed-by=$GPG_FILE] $BASE_URL/mkl all main" > /etc/apt/sources.list.d/intel-mkl.list

ARG year=2020

# Download debs and cache them
RUN apt-get update && \
    apt-get install -y -d --no-install-recommends \
                    $(apt-cache search intel-mkl-$year | cut -d '-' -f 1,2,3,4  | tail -n 1)

# Install MKL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    $(apt-cache search intel-mkl-$year | cut -d '-' -f 1,2,3,4  | tail -n 1)

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
