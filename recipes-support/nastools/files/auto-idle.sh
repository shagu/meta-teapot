#!/bin/bash

##
# HDD Auto Idle:
# 
#  Author:	Eric Mauser
#  License:	BSD
#  Version:	0.1
#
#  Info:
#  This script times the automatic shutdown of harddisks,   
#  that doesn't support it natively (hdparm -S120 $DEVICE),
#  but which are capable to shutdown manually 
#  with a command like: hdparm -y $DEVICE.
# 
#  Various Informations are written to:
#  state file:	/var/run/auto-idle
#  log file:	/var/log/auto-idle

##
# Configuration

MOUNT_POINT=/mnt/storage
DEVICE=/dev/sda
CHECK_INTERVAL=5
SUSPEND_INTERVAL=120
STATE="off"

##
# Only edit this part if you really know what you're doing

counter=$SUSPEND_INTERVAL
while true; do
	# Check if the Filesystem is in Use
	if [ -z "`fuser -c $MOUNT_POINT`" ]; then
		# Only decrease the counter while the NAS is on
		if [ "$STATE" == "on" ]; then
			if [ $counter -le 0 ]; then
				# Operations due NAS shutdown
				hdparm -y $DEVICE
				echo -e "`date`\t$DEVICE:\tShut down." >> /var/log/auto-idle
				STATE="off"
				counter=$SUSPEND_INTERVAL
			else
				# decrease conter
				counter=$(( $counter - 1 ))
			fi
		fi
	else
		# If the device came up recently, 
		#  make sure the NAS is up too
		if [ "$STATE" == "off" ]; then
			hdparm -C $DEVICE
			echo -e "`date`\t$DEVICE:\tFile access." >> /var/log/auto-idle
		fi

		# Reset Interval and State
		counter=$SUSPEND_INTERVAL
		STATE="on"
	fi
	
	# convert and write to /var/run/auto-idle
	counter_sec=$(( $counter * $CHECK_INTERVAL))
	counter_sec_max=$(( $SUSPEND_INTERVAL * $CHECK_INTERVAL))
	counter_minutes=$(( $counter_sec / 60 ))
	echo -e "[$STATE]\t Spindown in: $counter_sec/$counter_sec_max seconds. ($counter_minutes minutes)" > /var/run/auto-idle
	sleep $CHECK_INTERVAL
done &> /dev/null &
