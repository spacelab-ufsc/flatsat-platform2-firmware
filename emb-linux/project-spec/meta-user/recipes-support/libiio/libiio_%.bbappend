SRC_URI = "git://github.com/analogdevicesinc/libiio.git;protocol=https;branch=main"
           
inherit pkgconfig

DEPENDS += "pkgconfig-native"

SRCREV = "c4498c27761d04d4ac631ec59c1613bfed079da5"
PV = "0.24"

EXTRA_OECMAKE += "-DWITH_HWMON=ON"
