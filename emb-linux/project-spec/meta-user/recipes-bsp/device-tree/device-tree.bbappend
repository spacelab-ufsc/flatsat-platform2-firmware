FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "file://system-bsp.dtsi"

SRC_URI:append = " file://system-user.dtsi"

SRC_URI:append = " file://avnet-bsp.dtsi"

require ${@'device-tree-sdt.inc' if d.getVar('SYSTEM_DTFILE') != '' else ''}

do_configure:append () {
	if [ -e ${WORKDIR}/avnet-bsp.dtsi ]; then
		cp ${WORKDIR}/avnet-bsp.dtsi ${DT_FILES_PATH}/avnet-bsp.dtsi
	fi
}
