SUMMARY = "Flatsat device-tree overlays"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit rt-overlays

SRC_URI:microzed = "\
    file://flatsat-sensors.dts \
    file://axi-periph-config.dts \
    "
