SUMMARY = "FlatSat2 Read Sensors application"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsat_read_sensors.git;branch=master;protocol=https"

PV = "1.2+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "sqlite3 fsatutils"

inherit pkgconfig meson systemd

RS_SRC_DIR = "${datadir}/read-sensors"

EXTRA_OEMESON += "-Dsystemd_unitdir=${systemd_system_unitdir}"

SYSTEMD_SERVICE:${PN} = "read-sensors.service"

FILES:${PN} += "${systemd_system_unitdir}/read-sensors.service"
FILES:${PN} += "${bindir}/read-sensors"

# Automatically enable the service at boot
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
         install -d ${D}${systemd_system_unitdir}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
