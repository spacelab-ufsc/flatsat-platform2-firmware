DESCRIPTION = "Cubesat Space Protocol (CSP)"
SECTION = "connectivity"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2915dc85ab8fd26629e560d023ef175c"

SRCREV = "5e3905d103158f2c6198edbff04638a389e92414"

SRC_URI = "git://github.com/libcsp/libcsp.git;protocol=https;branch=libcsp-2-0 \
           file://0001-Add-address-selection-from-command-line.patch \
           "

S = "${WORKDIR}/git"
B = "${S}/builddir"

RDEPENDS:${PN} += "zeromq can-utils"
DEPENDS += "zeromq can-utils"

inherit pkgconfig meson

EXTRA_OEMESON += "-Dbuffer_size=2048"
EXTRA_OEMESON += "-Dbuffer_count=10"

FILES:${PN} += "${libdir}/libcsp.so"
FILES:${PN} += "${libdir}/libcsp.so.2.0"
FILES:${PN} += "/usr/csp/*"

PACKAGES =+ "${PN}-examples"

FILES:${PN}-examples = "${bindir}/*"

SOLIBS = ".so"
FILES_SOLIBSDEV = ""

do_compile:append() {
    meson compile -C ${B} zmqproxy csp_server_client
}

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${libdir}

    meson install --destdir="${D}" 
    install -m 755 ${B}/examples/zmqproxy ${D}${bindir}
    install -m 755 ${B}/examples/csp_server_client ${D}${bindir}
    install -m 755 ${B}/libcsp.so ${D}${libdir}

    if [ -f ${D}${libdir}/libcsp.so ]; then
        cp ${D}${libdir}/libcsp.so ${D}${libdir}/libcsp.so.2.0
    fi
}
