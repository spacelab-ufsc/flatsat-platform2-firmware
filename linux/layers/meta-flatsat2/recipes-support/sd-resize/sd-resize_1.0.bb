SUMMARY = "Initialize and grow the experiment SD partition on first boot"
DESCRIPTION = "On first boot, resizes the last SD partition (label 'experiment') \
to fill the remaining card space, formats it as ext4 if blank, and grows the \
filesystem otherwise."
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = " \
    file://sd-resize.sh \
    file://sd-resize.service \
"

S = "${WORKDIR}"

inherit systemd

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/sd-resize.sh ${D}${sbindir}/sd-rootfs-resize.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sd-resize.service \
        ${D}${systemd_system_unitdir}/sd-resize.service
}

SYSTEMD_SERVICE:${PN} = "sd-resize.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += " \
    ${sbindir}/sd-resize.sh \
    ${systemd_system_unitdir}/sd-resize.service \
"

RDEPENDS:${PN} = " \
    util-linux-findmnt \
    util-linux-blkid \
    util-linux-partx \
    parted \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    e2fsprogs-e2fsck \
"
