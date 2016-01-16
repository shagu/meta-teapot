DESCRIPTION = "Mainline Linux Kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel

require recipes-kernel/linux/linux-dtb.inc

DEPENDS += "lzop-native linux-firmware"

RDEPENDS_kernel-base += "kernel-modules"
RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

SRC_URI = "https://www.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz \
	  file://sunxi-sata-enable-pmp.patch \
          file://defconfig"

SRC_URI[md5sum] = "32cb4dd9f14d37bf71bafa6ed368f769"
SRC_URI[sha256sum] = "3ee2f2bdcb8ecf729fc7ed0545a6a2292f2853bd0eb259bc4124265a6ad4909f"

S = "${WORKDIR}/linux-${PV}"

do_configure_prepend () {
	# copy defconfig to .config
	cp ${WORKDIR}/defconfig ${S}/.config
}
