#
# This file is the read-sensors recipe.
#
SUMMARY = "FlatSat2 Read Sensors application"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "file://sensor.cpp \
           file://sensor.hpp \
           file://log.hpp \
           file://log.cpp \
           file://sensor-manager.cpp \
           file://sensor-manager.hpp \
           file://daemon.cpp \
           file://daemon.hpp \
           file://parser.hpp \
           file://main.cpp \
           file://LICENSE \
           file://Makefile \
		  "

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
         install -d ${D}/etc/fsat/read-sensors

         install -m 0644 ${WORKDIR}/sensor-manager.hpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/sensor-manager.cpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/sensor.cpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/sensor.hpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/main.cpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/log.cpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/log.hpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/daemon.hpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/daemon.cpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/parser.hpp ${D}/etc/fsat/read-sensors/
         install -m 0644 ${WORKDIR}/Makefile ${D}/etc/fsat/read-sensors/

	     install -d ${D}${bindir}
	     install -m 0755 read-sensors ${D}${bindir}
}
