#
# Copyright (C) 2014 Eric Mauser
#

SUMMARY = "Wifi package groups"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = "\
    wpa-supplicant \
    wireless-tools \
    "
