#!/bin/bash

if [[ -f "./images/linux/rootfs.wic" ]]; then
    petalinux-boot --qemu --kernel --rootfs ./images/linux
else
    echo "The necessary files for QEMU simulation are not in the standard path. Try running the build-image.sh script first!"
fi
