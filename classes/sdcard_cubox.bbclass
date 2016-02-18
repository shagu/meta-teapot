##
# Teapot Image Class for cubox

inherit image_types

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "boot"

# Use an uncompressed ext3 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"

# This image depends on the rootfs image
IMAGE_TYPEDEP_sdcard_cubox = "${SDIMG_ROOTFS_TYPE}"

SDIMG_ROOTFS = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"
SDIMG_BOOTFS = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.bootfs.${SDIMG_ROOTFS_TYPE}"

IMAGE_DEPENDS_sdcard_cubox = " \
			parted-native \
			mtools-native \
			dosfstools-native \
			virtual/kernel \
			u-boot-mkimage-native \
			"

# SD card image name
SDIMG = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.img"

IMAGE_CMD_sdcard_cubox () {

	ROOTFS_SIZE=`du -bks ${SDIMG_ROOTFS} | awk '{print $1}'` # in KiB
    BOOTFS_SIZE="48832"										 # in KiB

	SDSIZE=$(expr ${BOOTFS_SIZE} + ${ROOTFS_SIZE} + 2048)

	# Initialize sdcard image file
	dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDSIZE}

    # Create partition table
	parted -s ${SDIMG} mklabel msdos
	parted -s ${SDIMG} mkpart primary ext2 8192B 50003967B
	parted -s ${SDIMG} set 1 boot on
	parted -s ${SDIMG} mkpart primary ext2 50003968B 100%

	mkdir ${DEPLOY_DIR_IMAGE}/boot || true

	# Create boot.scr
	echo "setenv bootargs 'console=ttyS0,115200n8 vmalloc=384M root=/dev/mmcblk0p2 rootwait'" > ${DEPLOY_DIR_IMAGE}/bootcmd
	echo "ext2load mmc 0:1 0x00200000 /uImage" >> ${DEPLOY_DIR_IMAGE}/bootcmd
	echo "bootm" >> ${DEPLOY_DIR_IMAGE}/bootcmd
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "teapot boot script" -d ${DEPLOY_DIR_IMAGE}/bootcmd ${DEPLOY_DIR_IMAGE}/boot/boot.scr

	# Create uImage+dtb
	cat ${DEPLOY_DIR_IMAGE}/zImage ${DEPLOY_DIR_IMAGE}/zImage-dove-cubox.dtb > ${DEPLOY_DIR_IMAGE}/zImage.cubox
	mkimage -A arm -O linux -C none -T kernel -a 0x00008000 -e 0x00008000 -n 'Linux-cubox' -d ${DEPLOY_DIR_IMAGE}/zImage.cubox ${DEPLOY_DIR_IMAGE}/boot/uImage

	dd if=/dev/zero of=${SDIMG_BOOTFS} seek=$BOOTFS_SIZE count=0 bs=1k
	mkfs.ext3 -F ${SDIMG_BOOTFS} -d ${DEPLOY_DIR_IMAGE}/boot

	# Burn Partitions
	dd if=${SDIMG_BOOTFS} of=${SDIMG} conv=notrunc seek=1 bs=8192 && sync && sync
	dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=50003968 && sync && sync
	bzip2 -9f ${SDIMG}
}
