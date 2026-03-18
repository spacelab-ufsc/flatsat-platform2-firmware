#!/bin/sh

modprobe libcomposite

GADGET_DIR=/sys/kernel/config/usb_gadget/g1

mkdir -p $GADGET_DIR
cd $GADGET_DIR

echo 0x1d6b > idVendor    # Linux Foundation
echo 0x0104 > idProduct   # Ethernet Gadget

mkdir -p strings/0x409
echo "0000" > strings/0x409/serialnumber
echo "Avnet" > strings/0x409/manufacturer
echo "FlatSat2 USB Ether Gadget" > strings/0x409/product

mkdir -p configs/c.1/strings/0x409
echo "Config 1" > configs/c.1/strings/0x409/configuration
echo 120 > configs/c.1/MaxPower

mkdir -p functions/ecm.usb0
echo "02:12:34:56:78:9A" > functions/ecm.usb0/dev_addr   # device MAC
echo "02:98:76:54:32:10" > functions/ecm.usb0/host_addr  # host MAC

ln -s functions/ecm.usb0 configs/c.1/

ls /sys/class/udc > UDC
