FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "file://bsp.cfg"

SRC_URI:append = " file://platform-top.h file://flatsat.cfg"
