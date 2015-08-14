SUMMARY = "A very basic image with Sound features"
LICENSE = "MIT"

require base-image.bb

IMAGE_INSTALL += " \
    util-linux \
    coreutils \
	mpd \
	samba \
    libav \
"
