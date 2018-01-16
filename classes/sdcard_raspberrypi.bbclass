##
# Teapot Image Class for raspberrypi

inherit image_types

# This image depends on the rootfs image
IMAGE_TYPEDEP_sdcard_raspberrypi = "${SDIMG_ROOTFS_TYPE}"

# Set initramfs extension
KERNEL_INITRAMFS ?= ""

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "${MACHINE}"

# Boot partition size [in KiB] (will be rounded up to IMAGE_ROOTFS_ALIGNMENT)
BOOT_SPACE ?= "20480"

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT = "4096"

# Use an uncompressed ext3 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"
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

IMAGE_CMD_sdcard_raspberrypi () {

	# Align partitions
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	ROOTFS_SIZE=`du -bks ${SDIMG_ROOTFS} | awk '{print $1}'`

	ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE_ALIGNED} - ${ROOTFS_SIZE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	SDIMG_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + ${ROOTFS_SIZE_ALIGNED})

	echo "Creating filesystem with Boot partition ${BOOT_SPACE_ALIGNED} KiB and RootFS ${ROOTFS_SIZE_ALIGNED} KiB"

	# Initialize sdcard image file
	dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDIMG_SIZE}

	# Create partition table
	parted -s ${SDIMG} mklabel msdos
	# Create boot partition and mark it as bootable
	parted -s ${SDIMG} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
	parted -s ${SDIMG} set 1 boot on
	# Create rootfs partition to the end of disk
	parted -s ${SDIMG} -- unit KiB mkpart primary ext2 $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT}) -1s
	parted ${SDIMG} print

	# Create a vfat image with boot files
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
	rm ${WORKDIR}/boot.img || true
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS
	sync

	# Create config.txt
	echo 'kernel=u-boot.bin' > ${DEPLOY_DIR_IMAGE}/config.txt

	# Create uEnv.txt
	echo 'fdtfile=bcm2835.dtb' > ${DEPLOY_DIR_IMAGE}/uEnv.txt
	echo 'bootargs=earlyprintk console=ttyAMA0 console=tty1 root=/dev/mmcblk0p2 rootwait' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt
	echo 'bootcmd=mmc dev 0; fatload mmc 0:1 ${kernel_addr_r} zImage; fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}; bootz ${kernel_addr_r} - ${fdt_addr_r}' >> ${DEPLOY_DIR_IMAGE}/uEnv.txt

	# copy files
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/bcm2835-bootfiles/bootcode.bin ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/bcm2835-bootfiles/start.elf ::/
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/uEnv.txt ::/uEnv.txt
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/config.txt ::/config.txt
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/u-boot.bin ::/u-boot.bin		
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage ::/zImage		
	MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/zImage-bcm2835-rpi-b.dtb ::/bcm2835.dtb

	# Burn Partitions
	dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
	dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
	bzip2 -9f ${SDIMG}
}
