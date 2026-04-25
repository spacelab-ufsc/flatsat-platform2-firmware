FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:zedboard = " \
"

SRC_URI:append:microzed = " \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DT_CUSTOM_INCLUDES = ""

DT_CUSTOM_INCLUDES:append:zedboard = " \
    zed-leds.dtsi \
    zynq-zed.dtsi \
"

DT_CUSTOM_INCLUDES:append:microzed = " \
    avnet-bsp-conf.dtsi \
    microzed-avnet-bsp.dtsi \
"

SRC_URI:append = "${@' '.join(['file://' + f for f in d.getVar('DT_CUSTOM_INCLUDES').split()])}"

do_configure:append() {
    for name in ${DT_CUSTOM_INCLUDES}; do
        if [ -f "${WORKDIR}/${name}" ]; then
            cp ${WORKDIR}/${name} ${DT_FILES_PATH}/
            if ! grep -q "include.*${name}" ${DT_FILES_PATH}/system-top.dts; then
                echo "/include/ \"${name}\"" >> ${DT_FILES_PATH}/system-top.dts
            fi
        fi
    done
}
