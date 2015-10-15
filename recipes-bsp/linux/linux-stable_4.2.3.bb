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

SRC_URI[md5sum] = "936530a3b28f38ec9dbfa1fcabe9acd4"
SRC_URI[sha256sum] = "4ca6c783a0bc87573f5c95e49306cbe5f83dc1cd5afb44ecc9a1917f39e5ad66"

S = "${WORKDIR}/linux-${PV}"

do_configure_prepend () {
	# copy defconfig to .config
	cp ${WORKDIR}/defconfig ${S}/.config
}
