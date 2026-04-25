FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Config fragments and custom header
SRC_URI:append = " \
                 file://bsp.cfg \
                 "

SRC_URI:append:zedboard = " file://platform-top.h"
SRC_URI:append:microzed = " file://platform-top.h"

UBOOT_MACHINE_HEADER:zedboard = "platform-top.h"
UBOOT_MACHINE_HEADER:microzed = "platform-top.h"

do_configure:prepend() {
    if [ -f "${WORKDIR}/${UBOOT_MACHINE_HEADER}" ]; then
        install -m 0644 ${WORKDIR}/${UBOOT_MACHINE_HEADER} ${S}/include/configs/
    fi
}
