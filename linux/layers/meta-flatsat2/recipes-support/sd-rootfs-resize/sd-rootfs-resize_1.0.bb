SUMMARY = "Grow the last SD rootfs partition and ext4 filesystem on first boot"
DESCRIPTION = "Resizes the root partition to fill the remaining SD card space on first boot, then grows the ext4 filesystem."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://sd-rootfs-resize.sh \
    file://sd-rootfs-resize.service \
"

S = "${WORKDIR}"

inherit systemd

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/sd-rootfs-resize.sh ${D}${sbindir}/sd-rootfs-resize.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sd-rootfs-resize.service \
        ${D}${systemd_system_unitdir}/sd-rootfs-resize.service

    install -d ${D}${localstatedir}/lib
}

SYSTEMD_SERVICE:${PN} = "sd-rootfs-resize.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += " \
    ${sbindir}/sd-rootfs-resize.sh \
    ${systemd_system_unitdir}/sd-rootfs-resize.service \
    ${localstatedir}/lib \
"

RDEPENDS:${PN} += " \
    bash \
    util-linux \
    parted \
    e2fsprogs-resize2fs \
"
