#
# Copyright (C) 2014 Eric Mauser
#

SUMMARY = "default kernel drivers and firmware"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = "\
	kernel-modules \
	linux-firmware \
	"
