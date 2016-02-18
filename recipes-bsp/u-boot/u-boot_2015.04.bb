require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

# Tag v2015.04
SRCREV = "f33cdaa4c3da4a8fd35aa2f9a3172f31cc887b35"
SRC_URI = "git://git.denx.de/u-boot.git;branch=master;protocol=git \
           file://ecafe-esmil-uboot.patch \
           file://boot.cmd \
          "

COMPATIBLE_MACHINE = "armv7"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_compile_prepend () {
	# we dont want gcc to tune our binary
	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset TARGET_CFLAGS
}
