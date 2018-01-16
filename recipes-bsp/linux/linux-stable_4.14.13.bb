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
          file://orange-pi-zero-enable-analog-codec.patch \
          file://defconfig"

SRC_URI[md5sum] = "4e8bb562f8fd33d5ef1feb0435ed2b02"
SRC_URI[sha256sum] = "4ab46d1b5a0f8ef83b80760f89ae4f5c88431b19b3cf79ffa0c66d6b33e45772"

S = "${WORKDIR}/linux-${PV}"

# add required ecafe blobs to the kernel
addtask do_blobs before do_compile after do_configure
do_blobs () {
  if [ "${MACHINE}" = "ecafe" ]; then
    cd ${WORKDIR}/linux-${PV}
    git apply ${WORKDIR}/add-sdma-firmware-for-freescale-imx-socs.patch 2> /dev/null || true
    cp -rf ${PKG_CONFIG_SYSROOT_DIR}/lib/firmware/rt2870.bin firmware/
  fi
}


