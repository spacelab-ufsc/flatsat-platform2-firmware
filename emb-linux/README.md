# Zynq Embedded Linux project

## Table of Contents
- [Building the Project](#building-the-project)

## Building the project
The embedded linux distribution is developed using the petalinux tool from AMD (Xilinx). This project leverages Docker to build the image, making it inherently simple to build.

### Build dependencies

- Docker (Could be Desktop or Engine)
- Petalinux 2023.1 installer

### Building the image

After installing/downloading the dependencies the first step is to build the Docker image. For that one should run the following command in the emb-linux directory.


``` bash
docker build --build-arg PETA_RUN_FILE=<petalinux-installer-filename> -t petalinux:2023.1 .
```

After the Docker image builds, one should run the Docker container. This can be done by running the following command: 

``` bash
docker run --rm -it -v <absolute-path-to-flatsat-project>/flatsat-platform2-firmware/emb-linux/:/home/petalinux/project petalinux:2023.1 /bin/bash
```

Finally, to build the petalinux image one should run, inside the container, the following: 

``` bash
scripts/build-image.sh
```
