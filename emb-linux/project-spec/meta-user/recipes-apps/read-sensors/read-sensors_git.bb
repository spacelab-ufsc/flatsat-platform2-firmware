SUMMARY = "FlatSat2 Read Sensors application"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsat_read_sensors.git;branch=dev;protocol=https"

PV = "0.2.2+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "sqlite3 nlohmann-json libiio systemd"

inherit pkgconfig meson systemd

RS_SRC_DIR = "${datadir}/read-sensors"

EXTRA_OEMESON += "-Dsystemd_unitdir=${systemd_system_unitdir}"
EXTRA_OEMESON += "-Dinstall_src=true"
EXTRA_OEMESON += "-Dsrc_install_dir=${RS_SRC_DIR}"

SYSTEMD_SERVICE:${PN} = "read-sensors.service read-sensors.socket"

FILES:${PN} += "${systemd_system_unitdir}/read-sensors.service"
FILES:${PN} += "${systemd_system_unitdir}/read-sensors.socket"
FILES:${PN} += "${bindir}/read-sensors"

FILES:${PN}-dev = "${RS_SRC_DIR}"

# Automatically enable the service at boot
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
         install -d ${D}{RS_SRC_DIR}
         install -d ${D}${systemd_system_unitdir}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
