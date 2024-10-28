#!/bin/bash

echo "Starting to build FlatSat2 linux image..."

# Fixing the linux image name to the expected by meta-avnet
sed -i 's/BOOT.BIN/boot.bin/g' ./project-spec/meta-user/conf/petalinuxbsp.conf

# Fixing do_fetch step from broken recipes
sed -i 's/branch=master/branch=main/g' ./components/yocto/layers/poky/meta/recipes-extended/cracklib/cracklib_2.9.8.bb
sed -i 's/branch=master/branch=main/g' ./components/yocto/layers/poky/meta/recipes-support/bmap-tools/bmap-tools_git.bb

# Actually calling the petalinux tools
petalinux-build 

# Packaging the image
petalinux-package --boot --u-boot --fpga

# Generate the .wic file for QEMU 
petalinux-package --wic

# Refixing the linux image name because generating the .wic breaks it
sed -i 's/BOOT.BIN/boot.bin/g' ./project-spec/meta-user/conf/petalinuxbsp.conf
