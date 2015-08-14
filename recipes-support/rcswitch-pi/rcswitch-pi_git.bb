DESCRIPTION = "rcswitch-pi"
HOMEPAGE = ""
SECTION = "devel/libs"
LICENSE = "LGPLv3+"
LIC_FILES_CHKSUM = "file://${TOPDIR}/../meta-teapot/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

DEPENDS = "wiringpi"

S = "${WORKDIR}/git"

SRC_URI = "\
          git://github.com/r10r/rcswitch-pi.git \
          "

SRCREV = "2c9c027217ae0b4fe132e0725db166ac29f93974"

COMPATIBLE_MACHINE = "raspberrypi"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/git/send ${D}${bindir}/send
}

FILES_${PN} = "${bindir}"
