#
# Copyright (C) 2014 Eric Mauser
#

SUMMARY = "webserver package groups"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = "\
    lighttpd \
    php \
    "
