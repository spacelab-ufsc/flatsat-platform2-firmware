FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://80-can0.network"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/80-can0.network ${D}${systemd_unitdir}/network/80-can0.network
}

FILES:${PN} += "${systemd_unitdir}/80-can0.network"
