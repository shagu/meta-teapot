require u-boot.inc

DEPENDS += "dtc-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

# Tag: v2015.01
SRCREV = "92fa7f53f1f3f03296f8ffb14bdf1baefab83368"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master;protocol=git \
           file://ecafe-esmil-uboot.patch \
	   file://pandaboard-rev-a3.patch \
	   file://wandboard-uenv.patch \
          "

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_compile_prepend () {
	# we dont want gcc to tune our binary
	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset TARGET_CFLAGS
}
