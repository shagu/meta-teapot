SUMMARY = "Tevii s660"

LICENSE = "CLOSED"

SRC_URI = "\
  http://bitbucket.org/liplianin/s2-liplianin-v37/downloads/dvb-usb-s660.fw;md5sum=2946e99fe3a4973ba905fcf59111cf40 \
  http://bitbucket.org/liplianin/s2-liplianin-v37/downloads/dvb-fe-ds3000.fw;md5sum=a32d17910c4f370073f9346e71d34b80 \
  http://bitbucket.org/liplianin/s2-liplianin-v37/downloads/dvb-fe-ds3103.fw;md5sum=2c12c1931ead080490e91bbc181aa285 \
"

FILES_${PN} = "/lib/firmware"

do_install () {
  install -d ${D}/lib/firmware
  install -m 0744 ${WORKDIR}/dvb-usb-s660.fw ${D}/lib/firmware
  install -m 0744 ${WORKDIR}/dvb-fe-ds3000.fw ${D}/lib/firmware
  install -m 0744 ${WORKDIR}/dvb-fe-ds3103.fw ${D}/lib/firmware
}
