FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://80-can.network \
           file://80-eth.network \
           file://80-usb.network \
           "

do_install:append() {
    install -D -m 0644 ${WORKDIR}/80-can.network ${D}${systemd_unitdir}/network/80-can.network
    install -D -m 0644 ${WORKDIR}/80-usb.network ${D}${systemd_unitdir}/network/80-usb.network
    install -D -m 0644 ${WORKDIR}/80-eth.network ${D}${systemd_unitdir}/network/80-eth.network
}

FILES:${PN} += "${systemd_unitdir}/network/*.network"
