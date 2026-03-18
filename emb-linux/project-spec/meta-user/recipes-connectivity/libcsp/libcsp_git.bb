SUMMARY = "Cubesat Space Protocol"
HOMEPAGE = "https://github.com/libcsp/libcsp"
LICENSE = "LGPL2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=e438dd14b228d54d2cd2d56df9a3ff18"

SRC_URI = "git://github.com/libcsp/libcsp.git;branch=libcsp-1;protocol=https"

SRCREV = "affe7a62480c2e3840378d5bf14d4924019b5f2f"

PV = "1+git${SRCPV}"

inherit pkgconfig waf

DEPENDS += "libsocketcan zeromq can-utils"

PACKAGES =+ "${PN}-examples"

S = "${WORKDIR}/git"

EXTRA_OECONF += "--enable-examples --enable-if-zmq --enable-can-socketcan --enable-rdp --enable-hmac --enable-shlib --enable-debug-timestamp --with-driver-usart=linux --enable-crc32 --with-rtable=cidr --prefix=${prefix}"

EXTRA_OEWAF_INSTALL = "--destdir=${D} --prefix=${prefix}"

FILES:${PN} = "${libdir}/*.a ${libdir}/*.so*"
FILES:${PN}-dev = "${includedir}/* ${libdir}/*.pc"
FILES:${PN}-examples = "${bindir}/*"

RDEPENDS:${PN} += "libsocketcan zeromq"

INSANE_SKIP:${PN} += "dev-so"

SOLIBS = ".so"
FILES_SOLIBSDEV = ""
