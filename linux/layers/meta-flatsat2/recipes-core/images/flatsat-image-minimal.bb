SUMMARY = "Minimal FlatSat2 image"
LICENSE = "MIT"

require inc/flatsat-image-common.inc

IMAGE_INSTALL:append = " dtoverlay \
                         usb-ether \
                         sqlite3 \
                         libcsp \
                         libcsp-dev \
                         libcsp-examples \
                         fsatctl \
                        "
