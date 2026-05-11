# Common FlatSat2 image settings

inherit core-image

IMAGE_INSTALL = " \
                packagegroup-core-boot \
                kernel-modules \
                ethtool \
                iproute2 \
                mmc-utils \
                mtd-utils \
                can-utils \
                bridge-utils \
                u-boot-tools \
                run-postinsts \
                udev-extraconf \
                linux-xlnx-udev-rules \
                libiio \
                libiio-iiod \
                libiio-dev \
                libiio-tests \
                e2fsprogs-resize2fs \
                libgpiod-tools \
                i2c-tools \
                fsat2-engine \
                read-sensors \
                "

IMAGE_INSTALL:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'fpga-overlay', ' fpga-manager-script', '', d)}"
IMAGE_INSTALL:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'fpga-overlay', ' flatsat-bitstream', '', d)}"
IMAGE_INSTALL:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'fpga-overlay', ' dtoverlay', '', d)}"
