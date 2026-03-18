#!/usr/bin/env bash

USB_DEVICE_ID="03fd:0300"
export ROOT=$(readlink -f $(dirname "$BASH_SOURCE"))

if [ "$1" = "boot" ]; then
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../images/linux/BOOT.BIN -a BOOT.BIN
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../images/linux/boot.scr -a boot.scr
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../images/linux/uImage -a uImage
elif [ "$1" = "rootfs" ]; then
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../images/linux/rootfs.ext4 -a rootfs
else
    echo "Usage: $0 {boot|rootfs}"
    exit 1
fi
