FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILES:${PN} += "/etc/motd"

SRC_URI:append = " file://fstab.experiment"
SRC_URI:append:zedboard = " file://flatsat.motd"
SRC_URI:append:microzed = " file://flatsat.motd"

MOTD_FILE:zedboard = "flatsat.motd"
MOTD_FILE:microzed = "flatsat.motd"

hostname = "flatsat2-platform"

do_install:append() {
    if [ -n "${MOTD_FILE}" ]; then
        install -m 0644 ${WORKDIR}/${MOTD_FILE} ${D}${sysconfdir}/motd
    fi

    if ! grep -qE '^[^#]*[[:space:]]/boot[[:space:]]' ${D}${sysconfdir}/fstab; then
        grep '/boot'       ${WORKDIR}/fstab.experiment >> ${D}${sysconfdir}/fstab
    fi

    if ! grep -qE '^[^#]*[[:space:]]/experiment[[:space:]]' ${D}${sysconfdir}/fstab; then
        grep '/experiment' ${WORKDIR}/fstab.experiment >> ${D}${sysconfdir}/fstab
    fi
}
