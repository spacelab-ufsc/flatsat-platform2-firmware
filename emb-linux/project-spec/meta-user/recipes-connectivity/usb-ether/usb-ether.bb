DESCRIPTION = "USB Ethernet gadget setup script and systemd service"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = "file://setup_usb_gadget.sh \
           file://usb-ether.service"

S = "${WORKDIR}"

SYSTEMD_SERVICE:${PN} = "${BPN}.service"

SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
     install -d ${D}${bindir}
     install -d ${D}${systemd_system_unitdir}
     install -m 0755 setup_usb_gadget.sh ${D}${bindir}
     install -m 0644 ${BPN}.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${systemd_system_unitdir}/${BPN}.service"
FILES:${PN} += "${bindir}/setup_usb_gadget.sh"
