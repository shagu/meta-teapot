##
# Teapot Image Class for ecafe

inherit image_types

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "boot"

# Use an uncompressed ext3 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"

# This image depends on the rootfs image
IMAGE_TYPEDEP_sdcard_ecafe = "${SDIMG_ROOTFS_TYPE}"

SDIMG_ROOTFS = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"

do_image_sdcard[depends] += " \
			parted-native:do_populate_sysroot \
			mtools-native:do_populate_sysroot \
			dosfstools-native:do_populate_sysroot \
			virtual/kernel:do_deploy \
			virtual/bootloader:do_deploy \
    "

# SD card image name
SDIMG = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.img"


IMAGE_CMD_sdcard_ecafe () {
  ROOTFS_SIZE=`du -bks ${SDIMG_ROOTFS} | awk '{print $1}'` # in KiB
  BOOTFS_SIZE="44733"                                      # in KiB
  BOOT_ALIGNMENT="4096"                                    # in KiB

  # 4194kB is the space before first partition
  SDSIZE=$(expr 4096 + ${BOOTFS_SIZE} + 4096 + ${ROOTFS_SIZE} + 4096 + ${BOOT_ALIGNMENT} + 4096)

  # Initialize sdcard image file
  dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDSIZE}

  # Create partition table
  parted -s ${SDIMG} mklabel msdos
  parted -s ${SDIMG} mkpart primary fat32 4194kB 50,0MB
  parted -s ${SDIMG} set 1 boot on
  parted -s ${SDIMG} unit b mkpart primary ext2 50000384 100%

    # Create a vfat image with boot files
  BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
  rm -f ${WORKDIR}/boot.img 2> /dev/null
  mkfs.vfat -F 32 -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS

  # Create uEnv.txt
  #echo 'vram=16M coherent_pool=6M' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'linux=zImage' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'devicetree=imx51-na04.dtb' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
  echo 'options=console=ttymxc0,115200n8 console=tty1 root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait quiet' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt

  # Creat boot.ini
  echo '[default]' > ${DEPLOY_DIR_IMAGE}/boot.ini
  echo 'include=uEnv.txt' >> ${DEPLOY_DIR_IMAGE}/boot.ini
  echo '[fallback]' >> ${DEPLOY_DIR_IMAGE}/boot.ini
  echo 'include=uEnv.txt.bak' >> ${DEPLOY_DIR_IMAGE}/boot.ini

  MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage ::/
  MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage-imx51-na04.dtb ::/imx51-na04.dtb
  MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/uEnv.txt ::/
  MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.ini ::/

  # Burn Partitions
  dd if=${DEPLOY_DIR_IMAGE}/u-boot.imx of=${SDIMG} bs=1k seek=1 conv=notrunc && sync && sync
  dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=4193792 && sync && sync
  dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=50000384 && sync && sync
  bzip2 -9f ${SDIMG}
}
