#!/bin/bash

echo "Starting to build FlatSat2 linux image..."

# Fixing the linux image name to the expected by meta-avnet
sed -i 's/BOOT.BIN/boot.bin/g' ./project-spec/meta-user/conf/petalinuxbsp.conf

# Actually calling the petalinux tools
petalinux-build 

# Packaging the image
petalinux-package --boot --u-boot --fpga --force

# Generate the .wic file for QEMU 
petalinux-package --wic

# Refixing the linux image name because generating the .wic breaks it
sed -i 's/BOOT.BIN/boot.bin/g' ./project-spec/meta-user/conf/petalinuxbsp.conf
