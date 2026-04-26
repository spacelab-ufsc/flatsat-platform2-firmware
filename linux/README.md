# Zynq Embedded Linux project

## Table of Contents
- [Building the Project](#building-the-project)
- [Booting the Linux Image](#booting-the-linux-image)

## Building the project
The embedded linux distribution is developed using the Yocto project along with layers from AMD (Xilinx). This project relies on Yocto's build environment (i.e. bitbake), therefore a suited build environment must be prepared. The necessary setup for the build host can be found at [yocto project documentation](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#compatible-linux-distribution). Furthermore, the docker image [crops/poky](https://hub.docker.com/r/crops/poky), developed by CROss PlatformS (CROPS), can be used to setup a Poky container with the necessary tools to build the linux project.

### Build dependencies

- Yocto Project compatible Build Host (such as a Poky Container)

### Building the image

After installing/downloading the dependencies the first step is to prepare the build environment. For that one should run the following command in the linux directory.

``` bash
source sourcesdk
```

This command prepares the build environment setting the `TEMPLATECONF` env variable before sourcing poky's script, that way the local config and layers are properly set.

Next, run the following command to build the linux image for the microzed:

``` bash
bitbake flatsat-image-minimal-dev
```

>[!WARNING]
>The build should take quite some time and occupy at least 60GB of disk space, so have those in mind before building it!

After building the image, the image files should be deploy to the `build/tmp/deploy/images/microzed` directory.

#### Using a Poky container

In order to use a Poky container to build the FlatSat2 linux image, two simple commands must be ran before following the steps seen at [Building the image](#building-the-image). Essentially, they pull the `crops/poky` image from Docker Hub and then run the container; the commands can be seen below:

``` bash
docker pull crops/poky
```

``` bash
docker run --rm -it -v $(pwd):/workdir crops/poky --workdir=/workdir
```

>[!NOTE]
>The Poky container must have the `linux` directory inside the /workdir volume.

## Booting the linux image

In order to boot the image on MicroZed a SD card must be prepared and flashed with the wic image (naturally the MicroZed boot jumpers must also be configure to boot from the SD). After the build process the wic image should be in the deploy directory reference before and should be named as `flatsat2.wic`. Then, with the connected SD card and image file ready, you can use any flash tool that you desire, such as `dd` or `bmaptool`. 

Examples on how to flash the SD card can be seen below:

``` bash
sudo dd if=<path-to-wic-image>/flatsat2.wic of=<path-to-SD-card> bs=8M status=progress 
```

``` bash
sudo bmaptool copy <path-to-wic-image>/flatsat2.wic <path-to-SD-card>
```

After flashing the SD, you can simply connect it to MicroZed and power on the SoM. Just after power on you should see the U-Boot logs followed by kernel/systemd logs inside the MicroZed's console, which appears a serial port named `/dev/ttyUSBx` and can be interacted with something like `putty` and `minicom`.
