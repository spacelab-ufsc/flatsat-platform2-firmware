FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Removing Device Tree from Avnet BSP, since it conflicts with FPGA Manager
SRC_URI:remove = "file://system-bsp.dtsi"

SRC_URI:append = " file://system-user.dtsi"
SRC_URI:append = " file://avnet-bsp.dtsi"

require ${@'device-tree-sdt.inc' if d.getVar('SYSTEM_DTFILE') != '' else ''}
