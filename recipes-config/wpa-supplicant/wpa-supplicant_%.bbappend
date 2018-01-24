FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_prepend () {
  sed -i "s/WIFI_SSID/${TEAPOT_WIFI_SSID}/g" ${WORKDIR}/wpa_supplicant.conf-sane
  sed -i "s/WIFI_PASSWORD/${TEAPOT_WIFI_PASS}/g" ${WORKDIR}/wpa_supplicant.conf-sane
}
