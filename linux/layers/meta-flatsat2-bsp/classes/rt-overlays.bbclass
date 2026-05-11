DEPENDS += "dtc-native"

DT_OVERLAYS_INSTALL_DIR ?= "${nonarch_base_libdir}/firmware/overlays"

do_compile:append() {
    for dts in $(find ${WORKDIR} -maxdepth 1 -name '*.dts' -type f); do
        dtbo_name=$(basename "${dts}" .dts).dtbo
        bbdebug 1 "Compiling overlay: ${dts} -> ${dtbo_name}"
        dtc -@ -I dts -O dtb -o ${B}/${dtbo_name} ${dts}
    done
}

do_install:append() {
    install -d ${D}${DT_OVERLAYS_INSTALL_DIR}
    for dtbo in $(find ${B} -maxdepth 1 -name '*.dtbo' -type f); do
        install -m 0644 ${dtbo} ${D}${DT_OVERLAYS_INSTALL_DIR}/
    done
}

FILES:${PN} += "${DT_OVERLAYS_INSTALL_DIR}/*.dtbo"

RDEPENDS:${PN} += "fpga-manager-script dtoverlay"
