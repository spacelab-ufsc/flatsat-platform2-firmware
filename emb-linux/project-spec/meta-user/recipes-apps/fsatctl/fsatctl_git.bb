SUMMARY = "FlatSat2 command line test suite control"
SECTION = "PETALINUX/apps"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/c-porto/fsatctl.git;branch=master;protocol=https"

PV = "0.2.1+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "nlohmann-json"

inherit pkgconfig meson

FSATCTL_SRC_DIR = "${datadir}/fsatctl"

EXTRA_OEMESON += "-Dinstall_src=true"
EXTRA_OEMESON += "-Dsrc_install_dir=${FSATCTL_SRC_DIR}"

FILES:${PN} += "${bindir}/fsatctl"

FILES:${PN}-src = " \ 
            ${FSATCTL_SRC_DIR}/include \
            ${FSATCTL_SRC_DIR}/src \
            "

do_install() {
         install -d ${D}${FSATCTL_SRC_DIR}
	     install -d ${D}${bindir}

         meson install --destdir="${D}" 
}
