#!/bin/bash

function usage() {
    echo Usage: $0 \[command\]
    echo Valid Commands:
    echo -e \\t-c \[USB name \| USB BusID\]\\tConnect
    echo -e \\t-d \[USB name \| USB BusID\]\\tDisconnect
    echo -e \\t-r \[USB name \| USB BusID\]\\tReconnect
    echo -e \\t-l\\t\\t\\t\\tList
    echo 
    echo -e \\tUSB name is the name from usbipd list
    echo -e \\t\\tDisconnect target \"all\" removes all devices \(useful to remove persisted devs\)
    echo 
    echo example: $0 -c LimeSDR-USB
    echo example: $0 -c 1-20
    exit
}


function getDevID() {
    #####
    ### Find the USB device and attach it
    #####
    if [ $2 == "attach" ]; then
	filter="Not shared\|Shared"
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
    

[[ $# -eq 0 ]] && usage

while getopts "c:d:r:l" opt; do
    case "${opt}" in
	c)
	    [[ -z "${OPTARG}" ]] && usage
	    devid=$(getDevID "${OPTARG}" "attach")
	    [[ -z "${devid}" ]] && exit

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
	d)
	    [[ -z "${OPTARG}" ]] && usage

	    # This must be run as administrator which invokes a UAC popup
	    if [ "${OPTARG}" == "all" ]; then
		powershell.exe Start-Process powershell -Verb runAs -ArgumentList "@('usbipd','unbind','-a')"
	    else
		# Obtain the device bus ID
		devid=$(getDevID "${OPTARG}" "detach")
		[[ -z "${devid}" ]] && exit
		powershell.exe Start-Process powershell -Verb runAs -ArgumentList "@('usbipd','wsl','detach','--busid','${devid}')"
	    fi
	    ;;
	r)
	    [[ -z "${OPTARG}" ]] && usage
	    $0 -d "${OPTARG}"
	    # It is sometimes unable to locate the device if we stop/start too quickly
	    sleep 3
	    $0 -c "${OPTARG}"
	    ;;
	l)
	    usbipd.exe list
	    ;;
	*)
	    echo Invalid command
	    usage
	    ;;
    esac
done    
