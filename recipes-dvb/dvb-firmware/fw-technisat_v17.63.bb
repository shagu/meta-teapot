SUMMARY = "Technisat SkyStar USB HD"

LICENSE = "CLOSED"

SRC_URI = "http://kernellabs.com/firmware/technisat-usb2/dvb-usb-SkyStar_USB_HD_FW_v17_63.HEX.fw"

SRC_URI[md5sum] = "e313da69c3585435e7a02b543c5d668d"
SRC_URI[sha256sum] = "a81cd3b448fed1cd83105a2df32b5817a33f2583ac92a00e0341f1cf17b0c6ef"

FILES_${PN} = "/lib/firmware"

do_install () {
  install -d ${D}/lib/firmware
  install -m 0744 ${WORKDIR}/dvb-usb-SkyStar_USB_HD_FW_v17_63.HEX.fw ${D}/lib/firmware
}
