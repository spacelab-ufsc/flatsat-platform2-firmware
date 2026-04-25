#!/bin/sh
set -eu

STAMP_FILE="/var/lib/sd-rootfs-resized"

log() {
    echo "[sd-rootfs-resize] $*"
}

if [ -e "$STAMP_FILE" ]; then
    log "Already resized, nothing to do."
    exit 0
fi

ROOT_SRC="$(findmnt -n -o SOURCE /)"
if [ -z "${ROOT_SRC}" ]; then
    log "Could not determine root block device."
    exit 1
fi

case "${ROOT_SRC}" in
    /dev/mmcblk*p[0-9]*)
        DISK="${ROOT_SRC%p*}"
        PARTNUM="${ROOT_SRC##*p}"
        ;;
    /dev/sd[a-z][0-9]*|/dev/vd[a-z][0-9]*|/dev/xvd[a-z][0-9]*)
        DISK="$(echo "${ROOT_SRC}" | sed -E 's/[0-9]+$//')"
        PARTNUM="$(echo "${ROOT_SRC}" | sed -E 's/^.*[^0-9]([0-9]+)$/\1/')"
        ;;
    *)
        log "Unsupported root device format: ${ROOT_SRC}"
        exit 1
        ;;
esac

log "Root device: ${ROOT_SRC}"
log "Disk: ${DISK}"
log "Partition number: ${PARTNUM}"

# Require rootfs to be the last partition.
LAST_PART="$(parted -s "${DISK}" print | awk '
    /^[ ]*[0-9]+/ { p=$1 }
    END { print p }
')"

if [ "${LAST_PART}" != "${PARTNUM}" ]; then
    log "Root partition is not the last partition on disk; refusing to resize."
    exit 1
fi

# Grow partition to 100% of remaining space.
log "Resizing partition ${PARTNUM} on ${DISK} to 100%..."
parted -s "${DISK}" resizepart "${PARTNUM}" 100%

# Ask kernel to re-read the table. One of these typically works depending on kernel/userspace.
if command -v partprobe >/dev/null 2>&1; then
    partprobe "${DISK}" || true
fi

if command -v blockdev >/dev/null 2>&1; then
    blockdev --rereadpt "${DISK}" || true
fi

sleep 2
udevadm settle || true
sleep 1

log "Growing ext4 filesystem on ${ROOT_SRC}..."
resize2fs "${ROOT_SRC}"

touch "${STAMP_FILE}"
log "Resize completed successfully."
exit 0
