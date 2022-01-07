#!/bin/bash

# List of space separated services to start
START_SERVICES="dbus avahi-daemon ssh mysql"
# This is a special case, udev needs to be restarted not just started
RESTART_SERVICES="udev"

# Log all output to a bootlog file
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/var/log/bootlog.$(/usr/bin/date +%Y-%d-%m-%H.%M.%S) 2>&1

echo Bootup $(date)
echo =================== ENV ===============
env
echo =================== ENV ===============

# Start services
for i in ${START_SERVICES}; do
    service "${i}" start
done

# Restart services
for i in ${RESTART_SERVICES}; do
    service "${i}" restart
done

echo Done initializing $(date)
