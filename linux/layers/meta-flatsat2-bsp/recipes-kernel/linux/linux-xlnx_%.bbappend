FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://i2c-sensors.cfg \
            file://serial.cfg \
            file://enable-overlays.cfg \
            file://enable-vcan.cfg \
            file://enable-spi-dev.cfg \
            file://usb.cfg \
            file://enable-pwm.cfg \
            "

SRC_URI:append:zedboard = " file://usb-zedboard.cfg"
