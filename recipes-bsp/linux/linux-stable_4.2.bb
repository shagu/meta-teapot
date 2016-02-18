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
          file://add-sdma-firmware-for-freescale-imx-socs.patch;apply=false \
          file://dts-imx51-add-sahara-v4-entry.patch \
          file://dts-imx51-na04.patch \
          file://regulator-mc13892.patch \
          file://defconfig"

SRC_URI[md5sum] = "3d5ea06d767e2f35c999eeadafc76523"
SRC_URI[sha256sum] = "cf20e044f17588d2a42c8f2a450b0fd84dfdbd579b489d93e9ab7d0e8b45dbeb"

S = "${WORKDIR}/linux-${PV}"
do_configure_prepend () {
	# copy defconfig to .config
	cp ${WORKDIR}/defconfig ${S}/.config
}


# add required ecafe blobs to the kernel
addtask do_blobs before do_compile after do_configure
do_blobs () {
  cd ${WORKDIR}/linux-${PV}
  git apply ${WORKDIR}/add-sdma-firmware-for-freescale-imx-socs.patch 2> /dev/null || true
  cp -rf ${PKG_CONFIG_SYSROOT_DIR}/lib/firmware/rt2870.bin firmware/
}


