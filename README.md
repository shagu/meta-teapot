# Teapot Distribution

A yocto/openembedded layer for serveral ARM based boards.
This distribution is focused on minimal images 
with a bootable mainline kernel and u-boot.

![meta-teapot](http://mephis.he-hosting.de/teapot/teapot-white.png)

# Supported hardware
- **bananapi** (v1)
- **beaglebone** (black)
- **cubox** (the old marvel one)
- **ecafe** (netbook)
- **pandaboard** (revA3)
- **raspberrypi** (v1)
- **wandboard** (quad)

# Images
- **base-image**

	The default teapot image. All other images are based on it.
	It includes core and admin tools like:
	htop,vim,screen,wifi support, ssh, ...

- **dvb-image**

	A dvb image with tvheadend + dvb-firmware (tevii & technisat)

- **nas-image**

	The nas image ships all the tools you might want to see on a NAS.
	rsync, mdadm, lvm2, cryptsetup, samba, hdparm and a few convinience scripts.
	
	My setup: 
	- Banana Pi
	- [Sharkoon 5Bay Raid Box](https://de.sharkoon.com/product//11353#desc) 
	- 5x 2TB Western Digital harddrives


- **power-image**

	This image includes tools to manage wireless sockets with your raspberrypi (or other)

	My setup:
	- Raspberry Pi 
	- ["Funksteckdosen-Set"](http://www.pollin.de/shop/dt/MzMzOTQ0OTk-/Haustechnik/Funkschaltsysteme/Funksteckdosen_Set_mit_3_Steckdosen.html)
	- [434MHz RF Transmitter](http://www.amazon.de/gp/product/B007XEXICS)


- **sdk-image**

	A base image with development tools & headers

- **sound-image**

	A webradio/music-player image which uses "mpd" for playback.


# Instructions

### Setup OE:

	$ git clone git://git.openembedded.org/openembedded-core oe-core
	$ cd oe-core
	$ git clone git://git.openembedded.org/bitbake bitbake
	$ git clone git://git.openembedded.org/meta-openembedded


### Setup Teapot:

	$ git clone https://github.com/shagu/meta-teapot.git

### Prepare for the first build:

	$ source ./oe-init-build-env


### Configure local.conf (conf/local.conf):

	DISTRO ?= "teapot"


### Configure bblayers.conf (conf/bblayers.conf):

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

### First build:

	$ MACHINE=bananapi bitbake base-image
