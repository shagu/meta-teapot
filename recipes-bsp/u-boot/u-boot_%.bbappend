FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://boot.cmd"
SRC_URI += " file://ecafe-esmil-uboot.patch"
SRC_URI += " file://pandaboard-rev-a3.patch"
SRC_URI += " file://u-boot-pylibfdt-native-build.patch"

# sunxi fdt
DEPENDS += " bc-native dtc-native swig-native python3-native "

EXTRA_OEMAKE += ' HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}" '
