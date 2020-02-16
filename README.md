# intel-mkl-docker

Docker image that has intel-mkl installed. Provides debian image.

# Build locally

```shell
docker build -t intel-mkl /path/to/this/repo
```

Note that:

 - /path/to/this/repo can be the url to this repository, or it can be your local clone, or even a tar of the repository.
 - For `podman` user, replace `docker` with `podman` and every works fine (I tested building using `podman` on my computer).
