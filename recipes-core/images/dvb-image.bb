SUMMARY = "A very basic image with VDR features"
LICENSE = "MIT"

require base-image.bb

IMAGE_INSTALL += " \
    tvheadend \
    fw-technisat \
    fw-tevii \
"
