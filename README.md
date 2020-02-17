# intel-mkl-docker

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/nobodyxu/intel-mkl)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nobodyxu/intel-mkl)

![Docker Pulls](https://img.shields.io/docker/pulls/nobodyxu/intel-mkl)

tag `latest-ubuntu-bionic`:
![latest-ubuntu-bionic Layers](https://img.shields.io/microbadger/layers/nobodyxu/intel-mkl/latest-ubuntu-bionic)
![latest-ubuntu-bionic Size](https://img.shields.io/microbadger/image-size/nobodyxu/intel-mkl/latest-ubuntu-bionic)

tag `latest-debian-buster`:
![latest-debian-buster Layers](https://img.shields.io/microbadger/layers/nobodyxu/intel-mkl/latest-debian-buster)
![latest-debian-buster Size](https://img.shields.io/microbadger/image-size/nobodyxu/intel-mkl/latest-debian-buster)

Docker image that has intel-mkl installed. Provides debian:buster and ubuntu:bionic based images on docker hub.

## Pull from docker hub

```shell
# The below will pull newest intel-mkl for debian:buster
docker pull nobodyxu/intel-mkl:debian-buster

# The below will pull newest intel-mkl for ubuntu:bionic
docker pull nobodyxu/intel-mkl:ubuntu-bionic
```

## Build locally

```shell
# The below will build newest intel-mkl for debian:buster
docker build -t intel-mkl /path/to/this/repo

# If you want to build for ubuntu, use
docker build --build-arg base=ubuntu:bionic -t intel-mkl:ubuntu-bionic /path/to/this/repo

# You can change base to any version of debian-based or ubuntu-based system as you like
docker build --build-arg base=ubuntu:eoan -t intel-mkl:ubuntu-eoan /path/to/this/repo

# If you want intel-mkl to be from release of a different year, say, 2019, just pass build-arg year
docker build --build-arg year=2019 -t intel-mkl:2019 /path/to/this/repo

# You can mix two build-arg together:
docker build --build-arg year=2019 --build-arg base=ubuntu:bionic -t intel-mkl:ubuntu-bionic-2019 /path/to/this/repo
```

Note that:

 - `/path/to/this/repo` can be the url to this repository, or it can be your local clone, or even a tar of the repository.
 - For `podman` user, replace `docker` with `podman` and every works fine (I tested building using `podman` on my computer).
