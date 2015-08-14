require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=0507cd7da8e7ad6d6701926ec9b84c95"

# Tag: v2015.01
#SRCREV = "92fa7f53f1f3f03296f8ffb14bdf1baefab83368"
# Tag v2015.07
SRCREV = "33711bdd4a4dce942fb5ae85a68899a8357bdd94"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master;protocol=git \
	   file://boot.cmd \
          "

COMPATIBLE_MACHINE = "bananapi"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_compile_prepend () {
	# we dont want gcc to tune our binary
	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset TARGET_CFLAGS
}

do_compile_append() {
    ${S}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}
