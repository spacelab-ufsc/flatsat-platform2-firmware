# Common features for FlatSat2 Machines

YAML_DT_BOARD_FLAGS ?= ""
YAML_CONSOLE_DEVICE_CONFIG:pn-device-tree ?= "ps7_uart_1"
YAML_MAIN_MEMORY_CONFIG:pn-device-tree ?= "PS7_DDR_0"
YAML_SERIAL_CONSOLE_STDIN:pn-fsbl-firmware ?= "ps7_uart_1"
YAML_SERIAL_CONSOLE_STDOUT:pn-fsbl-firmware ?= "ps7_uart_1"
YAML_SERIAL_CONSOLE_BAUDRATE ?= "115200"
SERIAL_CONSOLES ?= "115200;ttyPS0"
DT_PADDING_SIZE:pn-device-tree ?= "0x1000"
DTC_FLAGS:pn-device-tree ?= "-@"

LOCAL_XSA_FILE ?= "${FLATSAT_BSP_LAYERDIR}/hw/xsa/flatsat2.xsa"
HDF_EXT ?= "xsa"
HDF_BASE ?= "file://"
HDF_PATH ?= "${LOCAL_XSA_FILE}"
HDF_MACHINE = ""

require conf/machine/zynq-generic.conf

SPL_BINARY ?= "spl/boot.bin"

IMAGE_FSTYPES:remove = "cpio cpio.gz cpio.gz.u-boot"
IMAGE_FSTYPES += "ext4 wic wic.bmap"

KERNEL_IMAGETYPES:remove = "zImage"

MACHINE_FEATURES += "fpga-overlay"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "flatsat-bitstream flatsat2-overlays"
