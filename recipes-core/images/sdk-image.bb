SUMMARY = "A very basic image with SDK features"
LICENSE = "MIT"

require base-image.bb

IMAGE_FEATURES += "dbg-pkgs dev-pkgs tools-sdk tools-debug"

IMAGE_INSTALL += " \
	bash \
	htop \
	subversion \
	git \
"
