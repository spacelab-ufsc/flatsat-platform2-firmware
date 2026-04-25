SUMMARY = "A collection of scripts and simple applications"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=4c01239e5c3a3d133858dedacdbca63c"

DEPENDS:append = " dtc"

PV = "1.0+git"

SRC_URI = "git://github.com/raspberrypi/utils;protocol=https;branch=master"

SRCREV = "e923ccad57d2a22f606c8fe0d1096e782a090fc9"

S = "${WORKDIR}/git"

OECMAKE_TARGET_COMPILE = "\
    dtmerge/all \
"

OECMAKE_TARGET_INSTALL = "\
    dtmerge/install \
"

inherit cmake
