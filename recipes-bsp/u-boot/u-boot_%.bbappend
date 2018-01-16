FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://boot.cmd"
SRC_URI += " file://ecafe-esmil-uboot.patch"
SRC_URI += " file://pandaboard-rev-a3.patch"
