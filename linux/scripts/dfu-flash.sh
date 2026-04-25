#!/usr/bin/env bash

USB_DEVICE_ID="03fd:0300"
export ROOT=$(readlink -f $(dirname "$BASH_SOURCE"))

if [[ -z $2 ]]; then
    echo "Usage: $0 {boot|rootfs} {MACHINE}"
    exit 1
fi

MACHINE="$2"

if [ "$1" = "boot" ]; then
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../build/tmp/deploy/images/$MACHINE/boot.bin -a boot.bin
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../build/tmp/deploy/images/$MACHINE/boot.scr -a boot.scr
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../build/tmp/deploy/images/$MACHINE/uImage -a uImage
elif [ "$1" = "rootfs" ]; then
    dfu-util -d $USB_DEVICE_ID -D $ROOT/../build/tmp/deploy/images/$MACHINE/flatsat2.ext4 -a rootfs
else
    echo "Usage: $0 {boot|rootfs} {MACHINE}"
    exit 1
fi
