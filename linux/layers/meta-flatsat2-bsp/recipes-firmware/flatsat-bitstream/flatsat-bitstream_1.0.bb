SUMMARY = "Flatsat bitstream for runtime programming"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit fpgamanager_dtg

SRC_URI:zedboard = "\
    file://zed.xsa \
    "

SRC_URI:microzed = "\
    file://v1_flatsat2.xsa \
    "

COMPATIBLE_MACHINE ?= "^$"
COMPATIBLE_MACHINE:zynq = ".*"
