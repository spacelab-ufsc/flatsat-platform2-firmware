SUMMARY = "FlatSat2 utilities library"
SECTION = "devtools"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1803fa9c2c3ce8cb06b4861d75310742"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsatutils.git;branch=master;protocol=https"

PV = "0.6+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "nlohmann-json zeromq libiio"

inherit pkgconfig meson

do_install() {
         meson install --destdir="${D}" 
}

FILES:${PN}-dev += "${libdir}/pkgconfig/*"
FILES:${PN}-dev += "${libdir}/include/*"
