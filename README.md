# meta-teapot

The meta-teapot distribution is a yocto/openembedded layer for serveral boards of different kind of platforms. The focus is on mainline kernels and bootloaders rather than using outdated or stucked vendor blobs. This layer also provides some small images for different use-cases.


# Setup Instructions

## Setup OE:

	$ git clone git://git.openembedded.org/openembedded-core oe-core
	$ cd oe-core
	$ git clone git://git.openembedded.org/bitbake bitbake
	$ git clone git://git.openembedded.org/meta-openembedded


## Setup Teapot:

	$ git clone https://github.com/shagu/meta-teapot.git

## Prepare for the first build:

	$ source ./oe-init-build-env


## Configure local.conf (conf/local.conf):

	DISTRO ?= "teapot"


## Configure bblayers.conf (conf/bblayers.conf):

	LCONF_VERSION = "5"

	BBPATH = "${TOPDIR}"
	BBFILES ?= ""

	BBLAYERS ?= " \
	  ${TOPDIR}/../meta \
	  ${TOPDIR}/../meta-teapot \
	  ${TOPDIR}/../meta-openembedded/meta-oe \
	  ${TOPDIR}/../meta-openembedded/meta-python \
	  ${TOPDIR}/../meta-openembedded/meta-networking \
	  "

	BBLAYERS_NON_REMOVABLE ?= " \
	  ${TOPDIR}/../meta \
	  "

## First build:

	$ MACHINE=bananapi bitbake base-image


# Supported Hardware

## MACHINE=bananapi
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/BPI-M1.jpg/300px-BPI-M1.jpg" align="right" height="100">

    SoC:      Allwinner A20[2]
    CPU:      ARM Cortex-A7 Dual-core (ARMv7-A) 1 GHz
    Memory:   1 GB
    Storage:  SD card & SATA 2.0

[Wikipedia](https://en.wikipedia.org/wiki/Banana_Pi)


## MACHINE=beaglebone
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Beaglebone_Black.jpg/220px-Beaglebone_Black.jpg" align="right" height="100">

    SoC:      TI AM335x
    CPU:      ARM Cortex-A8 1GHz
    Memory:   512MB DDR3 RAM
    Storage:  SD card & 4GB eMMC

[Wikipedia](https://en.wikipedia.org/wiki/BeagleBoard#BeagleBone_Black)


## MACHINE=cubox
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Cubox.png/250px-Cubox.png" align="right" height="100">

    SoC:      Marvell Armada 510
    CPU:      PJ4 core 800MHz
    Memory:   1GB
    Storage:  SD card

[Wikipedia)](https://en.wikipedia.org/wiki/CuBox)


## MACHINE=ecafe
<img src="https://www.hercules.com/thumb/phpThumb.php?q=95&w=308&h=308&src=/var/www/www.hercules.com/fichier/h_photo/623/photo_file_slimhdproductb715.png&f=jpeg&bg=FFFFFF" align="right" height="100">

    SoC:      Freescale i.MX51
    CPU:      ARM Cortex-A8 800MHz
    Memory:   512 MB
    Storage:  2x SD card, 20GB eMMC

[Website](https://www.hercules.com/de/legacy/bdd/p/157/ecafe-slim-hd-black-/)


## MACHINE=pandaboard
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/PandaBoard_described.png/220px-PandaBoard_described.png" align="right" height="100">

    SoC:      TI OMAP4460
    CPU:      ARM Cortex-A9 1GHz
    Memory:   1 GB
    Storage:  SD card

[Wikipedia](https://en.wikipedia.org/wiki/PandaBoard)


## MACHINE=raspberrypi
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Raspberry_Pi_-_Model_A.jpg/220px-Raspberry_Pi_-_Model_A.jpg" align="right" height="100">

    SoC:      Broadcom BCM2835
    CPU:      ARM11 700 MHz
    Memory:   512 MB
    Storage:  SD card

[Wikipedia](https://en.wikipedia.org/wiki/Raspberry_Pi)


## MACHINE=wandboard
<img src="https://www.wandboard.org/app/uploads/2017/06/Wandboard-Image.png" align="right" height="100">

    SoC:      Freescale i.MX6
    CPU:      ARM Cortex-A9 1 GHz
    Memory:   2 GB
    Storage:  SD card

[Website](https://www.wandboard.org/)


# Image Flavors

## base-image

The default teapot image and the core of all other teapot flavors. It includes basic utilities and administration tools:
* htop
* vim
* screen
* ssh
* ...

## dvb-image

An image featuring tvheadend and firmware drivers for some dvb hardware
* [TeVii S660 DVB-S2 USB](http://www.tevii.com/products_s660_1.asp)
* [Technisat SkyStar USB HD](https://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD)

## nas-image

The nas image ships all the tools you might want to see on a NAS. It also includes script and daemons to automatically suspend unused drives.
* rsync
* mdadm
* lvm2
* cryptsetup
* samba
* hdparm
* ...

### used hardware
* MACHINE=bananapi
* [Sharkoon 5Bay Raid Box](https://sharkoon.com/product/11353)
* 5x 2TB Western Digital harddrives


## power-image

A small image including tools to manage wireless sockets via rf-modules

### used hardware
* MACHINE=raspberrypi
* [Wireless sockets](https://www.pollin.de/p/funksteckdosen-set-mit-3-steckdosen-550666)
* [434MHz RF Transmitter](http://www.amazon.de/gp/product/B007XEXICS)

## sdk-image

A flavor which ships development tools and headers with the base image

## sound-image

A webradio/music-player image which uses "mpd" for playback.
