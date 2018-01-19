FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://boot.cmd"
SRC_URI += " file://ecafe-esmil-uboot.patch"
SRC_URI += " file://pandaboard-rev-a3.patch"
SRC_URI += " file://u-boot-pylibfdt-native-build.patch"

DEPENDS += " bc-native dtc-native swig-native python3-native u-boot-mkimage-native "

EXTRA_OEMAKE += ' HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}" '

do_deploy_append () {
  # create default boot.scr
  mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${DEPLOY_DIR_IMAGE}/boot.scr
}

do_deploy_raspberrypi_append ()  {
	# create config.txt
	echo 'kernel=u-boot.bin' > ${DEPLOY_DIR_IMAGE}/config.txt

	# create uEnv.txt
	echo 'fdtfile=bcm2835.dtb' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
	echo 'bootargs=earlyprintk console=ttyAMA0 console=tty1 root=/dev/mmcblk0p2 rootwait' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
	echo 'bootcmd=mmc dev 0; fatload mmc 0:1 ${kernel_addr_r} zImage; fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}; bootz ${kernel_addr_r} - ${fdt_addr_r}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
}

do_deploy_pandaboard_append () {
	# create uEnv.txt
  echo 'vram=16M coherent_pool=6M' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'fdtfile=omap4-panda.dtb' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'loadfdt=fatload mmc ${mmcdev} ${fdtaddr} ${fdtfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'loadimage=fatload mmc ${mmcdev} ${loadaddr} ${bootfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
}

do_deploy_ecafe_append () {
  # create uEnv.txt
  #echo 'vram=16M coherent_pool=6M' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'linux=zImage' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'devicetree=imx51-na04.dtb' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'options=console=ttymxc0,115200n8 console=tty1 root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait quiet' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt

  # creat boot.ini
  echo '[default]' > ${DEPLOY_DIR_IMAGE}/boot.ini
  echo 'include=uEnv.txt' >> ${DEPLOY_DIR_IMAGE}/boot.ini
  echo '[fallback]' >> ${DEPLOY_DIR_IMAGE}/boot.ini
  echo 'include=uEnv.txt.bak' >> ${DEPLOY_DIR_IMAGE}/boot.ini
}

do_deploy_beaglebone_append () {
	# Create uEnv.txt
  echo 'optargs=quiet coherent_pool=6M' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'fdtfile=am335x-boneblack.dtb' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'loadfdt=fatload mmc ${mmcdev} ${fdtaddr} ${fdtfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'loadimage=fatload mmc ${mmcdev} ${loadaddr} ${bootfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
}
