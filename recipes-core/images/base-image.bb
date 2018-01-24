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

set_image_root_pw() {
  sed -i "s_root::_root:${TEAPOT_ROOT_PASS}:_" ${IMAGE_ROOTFS}${sysconfdir}/shadow
}

set_image_config() {
  # disable ssh blank pw login
  sed -i 's_-B__' ${IMAGE_ROOTFS}${sysconfdir}/default/dropbear

  # set hostname
  echo "${IMAGE_HOSTNAME}" > ${IMAGE_ROOTFS}${sysconfdir}/hostname
}
