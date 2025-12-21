SUMMARY = "FlatSat2 ZMQ service engine"
SECTION = "PETALINUX/apps"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1803fa9c2c3ce8cb06b4861d75310742"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsat2-engine.git;branch=master;protocol=https"

PV = "1.2+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "zeromq systemd"

inherit pkgconfig meson systemd

EXTRA_OEMESON += "-Dsystemd_system_unitdir=${systemd_system_unitdir}"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

SYSTEMD_SERVICE:${PN} = "${BPN}.service"

FILES:${PN} += "${systemd_system_unitdir}/${BPN}.service"
FILES:${PN} += "${bindir}/${BPN}"

do_install() {
         install -d ${D}${systemd_system_unitdir}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
