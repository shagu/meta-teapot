##
# generic teapot sdcard image

# BOOT_LABEL:       set the boot partitions label
#                   default: "${MACHINE}"
#
# BOOT_SIZE:        set the boot partitions size
#                   default: "16384"
#
# BOOT_FILES:       a comma seperated list of files that should be copied to /boot
#                   default: "${KERNEL_IMAGETYPE} ${KERNEL_DEVICETREE}"
#
# SDIMG_SPL:        a file that should be copied into the mbr
#                   default: unset
#
# SDIMG_SPL_OFFSET: the offset where the SPL file should be copied to
#                   default: unset

inherit image_types

do_image_sdcard[depends] += " \
    ${IMAGE_BASENAME}:do_image_ext4 \
    parted-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    u-boot-mkimage-native:do_populate_sysroot \
    virtual/bootloader:do_deploy \
    virtual/kernel:do_deploy \
  "

# first partition begins at sector 2048 : 2048*1024 = 2097152
ALIGNMENT ?= "2048" 

SDIMG = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.img"
SDIMG_ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_NAME}.ext4"

BOOT_LABEL ?= "${MACHINE}"
BOOT_SIZE  ?= "16384"
BOOT_FILES ?= "${KERNEL_IMAGETYPE} ${KERNEL_DEVICETREE} ${UBOOT_SCRIPT}"

IMAGE_CMD_sdcard () {

  # calculate sizes
  BOOT_SIZE_REAL=$(expr ${BOOT_SIZE} + ${ALIGNMENT} - 1)
  BOOT_SIZE_REAL=$(expr ${BOOT_SIZE_REAL} - ${BOOT_SIZE_REAL} % ${ALIGNMENT})
  SDIMG_SIZE=$(expr ${ALIGNMENT} + ${BOOT_SIZE_REAL} + $ROOTFS_SIZE + ${ALIGNMENT})

  # create image file
  dd if=/dev/zero of=${SDIMG} bs=1 count=0 seek=$(expr 1024 \* ${SDIMG_SIZE})

  # setup partition table
  parted -s ${SDIMG} mklabel msdos
  parted -s ${SDIMG} unit KiB mkpart primary fat32 ${ALIGNMENT} $(expr ${BOOT_SIZE_REAL} \+ ${ALIGNMENT})
  parted -s ${SDIMG} set 1 boot on
  parted -s ${SDIMG} unit KiB mkpart primary ext2 $(expr ${BOOT_SIZE_REAL} \+ ${ALIGNMENT}) $(expr ${BOOT_SIZE_REAL} \+ ${ALIGNMENT} \+ ${ROOTFS_SIZE})

  # create boot image
  BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
  rm -f ${WORKDIR}/boot.img; mkfs.vfat -n "${BOOT_LABEL}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS

  # copy bootfiles
  for file in ${BOOT_FILES}; do 
    if echo $file | grep ":"; then
      source=$(echo $file | cut -d ":" -f 1)
      target=$(echo $file | cut -d ":" -f 2)
      MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/$source ::/$target
    else
      MTOOLS_SKIP_CHECK=1 mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/$file ::/
    fi
  done

  # burn raw bootloader
  if [ -n ${SDIMG_SPL} ] && [ -n ${SDIMG_SPL_OFFSET} ]; then
    dd if=${DEPLOY_DIR_IMAGE}/${SDIMG_SPL} of=${SDIMG} bs=${SDIMG_SPL_OFFSET} seek=1 conv=notrunc
  fi

  # burn partitions
  dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=$(expr ${ALIGNMENT} \* 1024)
  dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SIZE_REAL} + ${ALIGNMENT} \* 1024)
}

