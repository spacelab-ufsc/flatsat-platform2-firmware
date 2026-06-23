#include <configs/zynq-common.h>

#define DFU_ALT_INFO_MMC_BOOT                                                  \
  "updt_boot="                                                                 \
  "usb start;"                                                                 \
  "mmc dev 0;"                                                                 \
  "setenv dfu_alt_info "                                                       \
  "\"boot.bin fat 0 1\;"                                                       \
  "boot.scr fat 0 1\;"                                                         \
  "uImage fat 0 1\;"                                                           \
  "system.dtb fat 0 1\";"                                                      \
  "dfu 0 mmc 0\0"

#define DFU_ALT_INFO_MMC_ROOTFS                                                \
  "updt_rootfs="                                                               \
  "usb start;"                                                                 \
  "mmc dev 0;"                                                                 \
  "setenv dfu_alt_info "                                                       \
  "\"rootfs part 0 2\";"                                                       \
  "dfu 0 mmc 0\0"

#ifdef CONFIG_EXTRA_ENV_SETTINGS
#undef CONFIG_EXTRA_ENV_SETTINGS
#endif

#define CONFIG_EXTRA_ENV_SETTINGS                                              \
  "scriptaddr=0x20000\0"                                                       \
  "script_size_f=0x40000\0"                                                    \
  "fdt_addr_r=0x1f00000\0"                                                     \
  "pxefile_addr_r=0x2000000\0"                                                 \
  "kernel_addr_r=0x2000000\0"                                                  \
  "scriptaddr=0x3000000\0"                                                     \
  "ramdisk_addr_r=0x3100000\0" DFU_ALT_INFO_MMC_BOOT DFU_ALT_INFO_MMC_ROOTFS   \
      BOOTENV
