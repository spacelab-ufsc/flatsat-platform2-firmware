DESCRIPTION = "FlatSat "
SECTION = "base"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit systemd

SRC_URI = "file://read-sensors.service \
           file://LICENSE \
           file://read-sensors.socket"

S = "${WORKDIR}"

SYSTEMD_SERVICE:${PN} = "read-sensors.service read-sensors.socket"
#SYSTEMD_PACKAGES = "${PN}"

FILES_${PN} += "${systemd_system_unitdir}/read-sensors.service"
FILES_${PN} += "${systemd_system_unitdir}/read-sensors.socket"

# Enable the service by default
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/read-sensors.service ${D}${systemd_system_unitdir}/read-sensors.service
    install -m 0644 ${WORKDIR}/read-sensors.socket ${D}${systemd_system_unitdir}/read-sensors.socket
}
