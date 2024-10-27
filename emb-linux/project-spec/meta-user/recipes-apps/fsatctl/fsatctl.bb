#
# This file is the read-sensors recipe.
#
SUMMARY = "FlatSat2 command line test suite control"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "file://service.cpp \
           file://service.h \
           file://main.cpp \
           file://read-sensors.h \
           file://LICENSE \
           file://Makefile \
		  "

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
         install -d ${D}/etc/fsat/fsatctl

         install -m 0644 ${WORKDIR}/main.cpp ${D}/etc/fsat/fsatctl/
         install -m 0644 ${WORKDIR}/read-sensors.h ${D}/etc/fsat/fsatctl/
         install -m 0644 ${WORKDIR}/service.h ${D}/etc/fsat/fsatctl/
         install -m 0644 ${WORKDIR}/service.cpp ${D}/etc/fsat/fsatctl/
         install -m 0644 ${WORKDIR}/Makefile ${D}/etc/fsat/fsatctl/

	     install -d ${D}${bindir}
	     install -m 0755 fsatctl ${D}${bindir}
}
