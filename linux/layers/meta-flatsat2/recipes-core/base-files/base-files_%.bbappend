FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILES:${PN} += "/etc/motd"

SRC_URI:append:zedboard = " file://flatsat.motd"
SRC_URI:append:microzed = " file://flatsat.motd"

MOTD_FILE:zedboard = "flatsat.motd"
MOTD_FILE:microzed = "flatsat.motd"

do_install:append() {
    if [ -n "${MOTD_FILE}" ]; then
        install -m 0644 ${WORKDIR}/${MOTD_FILE} ${D}${sysconfdir}/motd
    fi
}
