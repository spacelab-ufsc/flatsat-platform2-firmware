FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2024-10-13-03-00-00.cfg \
            file://user_2024-10-13-03-22-00.cfg \
            "

