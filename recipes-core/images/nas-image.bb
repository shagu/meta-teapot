SUMMARY = "A very basic image with NAS features"
LICENSE = "MIT"

require base-image.bb

IMAGE_HOSTNAME = "thor"

IMAGE_INSTALL += " \
	git \
	rsync \
	mdadm \
	lvm2 \
	cryptsetup \
	samba \
	hdparm \
	nastools \
"
