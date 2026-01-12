SUMMARY = "FlatSat2 OBDH2 Simulator"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/obdh2-sim.git;branch=master;protocol=https \
           "

PV = "0.1.3+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "zeromq sqlite3 libgpiod"

inherit pkgconfig meson systemd

EXTRA_OEMESON += "-Dsystemd_system_unitdir=${systemd_system_unitdir}"

SYSTEMD_SERVICE:${PN} = "${BPN}.service"

FILES:${PN} += "${systemd_system_unitdir}/${BPN}.service"
FILES:${PN} += "${bindir}/${BPN}"

SYSTEMD_AUTO_ENABLE = "disable"

do_install() {
         install -d ${D}${systemd_system_unitdir}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
