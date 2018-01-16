SUMMARY = "A very basic image"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management"

inherit core-image distro_features_check

IMAGE_HOSTNAME = "teapot"

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_INSTALL += " \
	packagegroup-core-ssh-dropbear \
	packagegroup-teapot-drivers \
	packagegroup-teapot-wifi \
	packagegroup-teapot-tools \
  bash \
"

ROOTFS_POSTPROCESS_COMMAND += "set_image_root_pw;set_image_config;"
IMAGE_ROOTPW ?= '\$6\$wixdy8pV\$Dfgu6z1oj2iXI9sWrUZptm7CGea//P0h1OYKLjBiYYJAMj/R/hWXi.WuyFWt2aPpdNInINeRxS0lk4y2Xvx/5.'

set_image_root_pw() {
  sed -i "s_root::_root:${IMAGE_ROOTPW}:_" ${IMAGE_ROOTFS}${sysconfdir}/shadow
}

set_image_config() {
  # disable ssh blank pw login
  sed -i 's_-B__' ${IMAGE_ROOTFS}${sysconfdir}/default/dropbear

  # set hostname
  echo "${IMAGE_HOSTNAME}" > ${IMAGE_ROOTFS}${sysconfdir}/hostname
}
