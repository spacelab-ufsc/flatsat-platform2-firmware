#
# This file is the read-sensors recipe.
#
SUMMARY = "FlatSat2 Read Sensors application"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsat_read_sensors.git;branch=master;protocol=https"

PV = "0.1.0+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "sqlite3"

inherit pkgconfig meson systemd

EXTRA_OEMESON += "-Dsystemd_unitdir=${systemd_system_unitdir}"
EXTRA_OEMESON += "-Dinstall_src=false"
EXTRA_OEMESON += "-Dsrc_install_dir=${D}/etc/fsat/read-sensors"

SYSTEMD_SERVICE:${PN} = "read-sensors.service read-sensors.socket"

FILES_${PN} += "${systemd_system_unitdir}/read-sensors.service"
FILES_${PN} += "${systemd_system_unitdir}/read-sensors.socket"
FILES_${PN} += "${bindir}/read-sensors"

# Automatically enable the service at boot
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
         install -d ${D}/etc/fsat/read-sensors
         install -d ${D}${systemd_system_unitdir}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
