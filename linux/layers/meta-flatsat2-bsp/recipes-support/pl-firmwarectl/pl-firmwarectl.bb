SUMMARY = "Command-line helper for runtime PL bitstreams and device-tree overlays"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = " \
    file://pl-firmwarectl \
    file://pl-firmwarectl.bash-completion \
"

S = "${WORKDIR}"

RDEPENDS:${PN} += " \
    python3-core \
    python3-json \
    python3-shell \
    python3-profile \
    fpga-manager-script \
    dtoverlay \
"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/pl-firmwarectl ${D}${bindir}/pl-firmwarectl

    install -d ${D}${sysconfdir}/bash_completion.d
    install -m 0644 ${WORKDIR}/pl-firmwarectl.bash-completion \
        ${D}${sysconfdir}/bash_completion.d/pl-firmwarectl
}
