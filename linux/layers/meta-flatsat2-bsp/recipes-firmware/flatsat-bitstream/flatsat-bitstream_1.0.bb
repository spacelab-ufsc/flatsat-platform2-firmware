SUMMARY = "Flatsat bitstream for runtime programming"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit fpgamanager_dtg

SRC_URI:zedboard = "\
    file://v1_zed.xsa \
    "

SRC_URI:microzed = "\
    file://v1_flatsat2.xsa \
    "

COMPATIBLE_MACHINE ?= "^$"
COMPATIBLE_MACHINE:zynq = ".*"
