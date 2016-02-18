#
# Copyright (C) 2014 Eric Mauser
#

SUMMARY = "default tools package groups"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = "\
    udev-extraconf \
	psmisc \
	util-linux \
    htop \
    vim \
	screen \
    "
