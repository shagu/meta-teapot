##
# Teapot Image Class for pandaboard

inherit image_types

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "boot"

# Use an uncompressed ext3 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"

# This image depends on the rootfs image
IMAGE_TYPEDEP_sdcard_pandaboard = "${SDIMG_ROOTFS_TYPE}"

SDIMG_ROOTFS = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"

IMAGE_DEPENDS_sdcard_pandaboard = " \
			parted-native \
			mtools-native \
			dosfstools-native \
			virtual/kernel \
			virtual/bootloader \
			"

# SD card image name
SDIMG = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.img"

IMAGE_CMD_sdcard_pandaboard () {
	ROOTFS_SIZE=`du -bks ${SDIMG_ROOTFS} | awk '{print $1}'` # in KiB
    BOOTFS_SIZE="48832"																			 # in KiB

	SDSIZE=$(expr ${BOOTFS_SIZE} + ${ROOTFS_SIZE} + 2048)

	# Initialize sdcard image file
	dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDSIZE}

    # Create partition table
	parted -s ${SDIMG} mklabel msdos
	parted -s ${SDIMG} mkpart primary fat32 8192B 50003967B
	parted -s ${SDIMG} set 1 boot on
	parted -s ${SDIMG} mkpart primary ext2 50003968B 100%

	# Create uEnv.txt
    echo 'vram=16M coherent_pool=6M' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
    echo 'fdtfile=omap4-panda.dtb' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
    echo 'loadfdt=fatload mmc ${mmcdev} ${fdtaddr} ${fdtfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
    echo 'loadimage=fatload mmc ${mmcdev} ${loadaddr} ${bootfile}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt

	# Create a vfat image with boot files
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
  rm -f ${WORKDIR}/boot.img 2> /dev/null
	mkfs.vfat -F 32 -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS

    export MTOOLS_SKIP_CHECK=1
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/u-boot.img ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/MLO ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/uEnv.txt ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage-omap4-panda.dtb ::/omap4-panda.dtb

	# Burn Partitions
	dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=8192 && sync && sync
	dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=50003968 && sync && sync
	bzip2 -9f ${SDIMG}
}
