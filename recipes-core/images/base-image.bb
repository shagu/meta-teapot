SUMMARY = "A very basic image"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management"

inherit core-image distro_features_check

IMAGE_HOSTNAME = "teapot"

IMAGE_INSTALL = "packagegroup-core-boot ${ROOTFS_PKGMANAGE_BOOTSTRAP} ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_INSTALL += " \
	packagegroup-core-drivers \
	packagegroup-core-ssh-dropbear \
	packagegroup-core-wifi \
	packagegroup-core-tools \
"

ROOTFS_POSTPROCESS_COMMAND += "set_image_root_pw;set_image_config;"
IMAGE_ROOTPW ?= '\$6\$54br3cyl\$5FYhTslAwHe8oDiBQkg0bS3iwtfBt0nMpkjqjdeVCDEYvqbCWYk3itLZQ3T6f8VJ0X8R0.Wf3K0.dleqKp6ib.'

set_image_root_pw() {
  sed -i "s_root::_root:${IMAGE_ROOTPW}:_" ${IMAGE_ROOTFS}${sysconfdir}/shadow
}

set_image_config() {
  # disable ssh blank pw login
  sed -i 's_-B__' ${IMAGE_ROOTFS}${sysconfdir}/default/dropbear

  # set hostname
  echo "${IMAGE_HOSTNAME}" > ${IMAGE_ROOTFS}${sysconfdir}/hostname
}
