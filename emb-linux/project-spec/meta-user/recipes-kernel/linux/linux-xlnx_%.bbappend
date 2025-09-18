FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://i2c-sensors.cfg \
            file://serial.cfg \
            file://enable-pwm.cfg \
            "
