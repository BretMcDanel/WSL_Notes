#!/bin/bash

function usage() {
    echo Usage: $0 \[command\] \[USB name \| USB BusID\]
    echo -e \\tcommand is connect, disconnect, reconnect
    echo 
    echo -e \\tUSB name is the name from usbipd list
    echo 
    echo example: $0 connect LimeSDR-USB
    echo example: $0 connect 1-20
    exit
}


function getDevID() {
    #####
    ### Find the USB device and attach it
    #####
    if [ $2 == "attach" ]; then
	filter="Not shared"
    else
	filter="Attached"
    fi
    
    if [[ ! $1 =~ ^[0-9]{1,2}-[0-9]{1,3}$ ]]; then
	devinfo=$(usbipd.exe list | grep "${filter}" | grep "${1}")

	if [ -z "${devinfo%% *}" ]; then
	    echo Unable to locate device \($1\) >&2
	    exit
	fi

	if [ $(echo "${devinfo}" | wc -l) -gt 1 ]; then
	    echo Multiple devices found, attaching first found device \(${devinfo%% *}\) >&2
	fi

	echo ${devinfo%% *}
    else
	echo $1
    fi
}
    
    
if [ $# -ne 2 ]; then
    usage
fi

case $1 in
    connect | start)
	devid=$(getDevID $2 "attach")

	#####
	### Ensure udev is running
	#####
	sudo service udev status
	if [ $? -ne 0 ]; then
	    # start tries to run in this shell, restart does not
	    sudo service udev restart
	fi
	
	#####
	### Get USBIPD Status, launch if required
	#####
	status=$(powershell.exe '(Get-Service usbipd).Status')
	status=${status//[$'\t\r\n ']}
	
	if [ "${status}" != "Running" ]; then
	    echo USBIPD Status is ${status}
	    echo Starting USBIPD service
	    # This must be run as administrator which invokes a UAC popup
	    powershell.exe Start-Process powershell -Verb runAs -ArgumentList "@('Start-Service','usbipd')"
	fi


	# This must be run as administrator which invokes a UAC popup
	powershell.exe Start-Process powershell -Verb runAs -ArgumentList "@('usbipd','wsl','attach','-d','${WSL_DISTRO_NAME}','--busid','${devid}')"

	;;
    disconnect | stop)
	# Obtain the device bus ID
	devid=$(getDevID $2 "detach")

	# This must be run as administrator which invokes a UAC popup
	powershell.exe Start-Process powershell -Verb runAs -ArgumentList "@('usbipd','wsl','detach','--busid','${devid}')"
	;;
    reconnect | restart)
	$0 stop
	# It is sometimes unable to locate the device if we stop/start too quickly
	sleep 3
	$0 start
	;;
    *)
	echo Invalid command
	usage
	;;
esac
