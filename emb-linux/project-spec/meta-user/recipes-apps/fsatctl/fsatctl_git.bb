SUMMARY = "FlatSat2 command line test suite control"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsatctl.git;branch=master;protocol=https"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "nlohmann-json fsatutils"

inherit pkgconfig meson

FSATCTL_SRC_DIR = "${datadir}/fsatctl"

FILES:${PN} += "${bindir}/fsatctl"

do_install() {
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
