#!/bin/sh
set -eu

STAMP_FILE="/var/lib/sd-experiment-initialized"
EXP_LABEL="experiment"
EXP_MOUNT="/experiment"

log() {
    echo "[sd-experiment-init] $*"
}

if [ -e "$STAMP_FILE" ]; then
    log "Already initialized, nothing to do."
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
        PART_PREFIX="${DISK}p"
        ;;
    /dev/sd[a-z][0-9]*|/dev/vd[a-z][0-9]*|/dev/xvd[a-z][0-9]*)
        DISK="$(echo "${ROOT_SRC}" | sed -E 's/[0-9]+$//')"
        PART_PREFIX="${DISK}"
        ;;
    *)
        log "Unsupported root device format: ${ROOT_SRC}"
        exit 1
        ;;
esac

# Find the experiment partition by label, falling back to partition 3.
EXP_DEV="$(blkid -L "${EXP_LABEL}" 2>/dev/null || true)"
if [ -z "${EXP_DEV}" ]; then
    EXP_DEV="${PART_PREFIX}3"
fi

if [ ! -b "${EXP_DEV}" ]; then
    log "Experiment partition ${EXP_DEV} not found."
    exit 1
fi

PARTNUM="$(echo "${EXP_DEV}" | sed -E 's/^.*[^0-9]([0-9]+)$/\1/')"

log "Disk: ${DISK}"
log "Experiment partition: ${EXP_DEV} (#${PARTNUM})"

# Require experiment to be the last partition before growing.
LAST_PART="$(parted -s "${DISK}" print | awk '
    /^[ ]*[0-9]+/ { p=$1 }
    END { print p }
')"

if [ "${LAST_PART}" != "${PARTNUM}" ]; then
    log "Experiment is not the last partition on disk; refusing to resize."
    exit 1
fi

log "Resizing partition ${PARTNUM} on ${DISK} to 100%..."
parted -s "${DISK}" resizepart "${PARTNUM}" 100%

if command -v partx >/dev/null 2>&1; then
    partx -u "${EXP_DEV}" 2>/dev/null || true
fi

sleep 2
udevadm settle || true
sleep 1

# Format if there is no filesystem yet; otherwise grow the existing one.
FSTYPE="$(blkid -o value -s TYPE "${EXP_DEV}" 2>/dev/null || true)"
if [ -z "${FSTYPE}" ]; then
    log "No filesystem on ${EXP_DEV}, creating ext4..."
    mkfs.ext4 -F -L "${EXP_LABEL}" "${EXP_DEV}"
elif [ "${FSTYPE}" = "ext4" ] || [ "${FSTYPE}" = "ext3" ] || [ "${FSTYPE}" = "ext2" ]; then
    log "Checking ${FSTYPE} filesystem on ${EXP_DEV}..."
    # resize2fs refuses to grow a filesystem that hasn't been cleanly checked.
    # -p = preen (auto-fix safe issues); exit 0/1 are both fine to continue.
    e2fsck -p -f "${EXP_DEV}" || rc=$? && rc=${rc:-0}
    if [ "${rc}" -gt 1 ]; then
        log "e2fsck reported uncorrectable errors (rc=${rc}); aborting."
        exit "${rc}"
    fi
    log "Growing ${FSTYPE} filesystem on ${EXP_DEV}..."
    resize2fs "${EXP_DEV}"
else
    log "Unexpected filesystem ${FSTYPE} on ${EXP_DEV}; leaving as-is."
fi

mkdir -p "${EXP_MOUNT}"

touch "${STAMP_FILE}"
log "Experiment partition initialization completed."
exit 0
