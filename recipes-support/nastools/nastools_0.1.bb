SUMMARY = "Helper Scripts and Auto Suspend for NAS"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${TOPDIR}/../meta-teapot/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://auto-idle.sh \
           file://init \
           "

RDEPENDS_${PN} = "bash"

DEPENDS = " \
  mdadm \
  cryptsetup \
  samba \
  hdparm \
"

inherit update-rc.d

INITSCRIPT_NAME = "auto-idle"
INITSCRIPT_PARAMS = "start 01 2 3 4 5 . stop 80 0 6 1 ."

do_install () {
 install -d ${D}${sysconfdir}/init.d \
 	${D}${sbindir}
 install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/auto-idle
 install -m 0755 ${WORKDIR}/auto-idle.sh ${D}${sbindir}/auto-idle
}
