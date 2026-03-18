FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILES:${PN} += "/etc/motd"

SRC_URI += "file://flatsat.motd"

do_install:append() {
    install -m 0644 ${WORKDIR}/flatsat.motd ${D}${sysconfdir}/motd
}
