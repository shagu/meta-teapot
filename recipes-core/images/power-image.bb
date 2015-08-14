SUMMARY = "A very basic image with POWER features"
LICENSE = "MIT"

require base-image.bb

IMAGE_INSTALL += " \
	packagegroup-core-nfs-server \
	wiringpi \
	rcswitch-pi \
"
