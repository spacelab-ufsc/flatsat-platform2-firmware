#!/bin/sh

modprobe libcomposite
modprobe usb_f_ecm || true
modprobe usb_f_mass_storage || true

GADGET_DIR=/sys/kernel/config/usb_gadget/g1
IMG=/opt/usbshare.img

# Create /opt directory
#mkdir -p /opt

# Create the backing file once
#if [ ! -f "$IMG" ]; then
#    truncate -s 128M "$IMG"
#    mkfs.vfat "$IMG"
#fi

mkdir -p $GADGET_DIR
cd $GADGET_DIR

if [ -f UDC ]; then
    echo "" > UDC || true
fi

echo 0x1d6b > idVendor    # Linux Foundation
echo 0x0104 > idProduct   # Ethernet Gadget
echo 0x0200 > bcdUSB
echo 0x0100 > bcdDevice

mkdir -p strings/0x409
echo "0000" > strings/0x409/serialnumber
echo "Avnet" > strings/0x409/manufacturer
echo "FlatSat2 USB Ether/Storage Gadget" > strings/0x409/product

mkdir -p configs/c.1/strings/0x409
echo "ECM + Mass Storage" > configs/c.1/strings/0x409/configuration
echo 120 > configs/c.1/MaxPower

# Ethernet Function
mkdir -p functions/ecm.usb0
echo "02:12:34:56:78:9A" > functions/ecm.usb0/dev_addr   # device MAC
echo "02:98:76:54:32:10" > functions/ecm.usb0/host_addr  # host MAC

# Mass-storage function
#mkdir -p functions/mass_storage.0
#echo 1 > functions/mass_storage.0/stall
#echo "$IMG" > functions/mass_storage.0/lun.0/file
#echo 0 > functions/mass_storage.0/lun.0/ro
#echo 1 > functions/mass_storage.0/lun.0/removable

ln -s functions/ecm.usb0 configs/c.1/ || true
#ln -s functions/mass_storage.0 configs/c.1/ || true

UDC_NAME="$(ls /sys/class/udc | head -n1)"
[ -n "$UDC_NAME" ] || { echo "No UDC found"; exit 1; }
echo "$UDC_NAME" > UDC
