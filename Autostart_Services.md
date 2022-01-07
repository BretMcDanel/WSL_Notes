# Autostart services

## Background
I had previously worked on starting systemd to spawn services that I use.  This was hacky and prone to breakage, especially in edge cases.  I tried a few different scripts, none of them worked in my particular environment.  I then noticed a [comment](https://discourse.ubuntu.com/t/desktop-team-updates-monday-15th-november-2021/25197/6) by an Ubuntu contributor **[didrocks](https://discourse.ubuntu.com/u/didrocks/summary)** from November 2021 which read "PoC of systemd on WSL at startup of an instance"

This led me to believe that my time is wasted as whatever solution I come up with will become depricated in the near future.  As a result I have decided to focus my time elsewhere and leave it with this simple, yet still hacky, start up script.

## /etc/wsl.conf
Add the following to /etc/wsl.conf (I believe it requires Windows 11 or above for the WSL subsystem to support this).

Note: you cannot just invoke systemd here, it has to be run differently.  Then you will have to deal with namespaces and if you use them for other things you can experience breakage.

```
[boot]
command = /etc/runAtStartup.sh
```

## The Script
I use a simple logging script, its not pretty but it works.

```
#!/bin/bash

# List of space separated services to start
SERVICES="dbus avahi-daemon ssh mysql"

# Log all output to a bootlog file
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/var/log/bootlog.$(/usr/bin/date +%Y-%d-%m-%H.%M.%S) 2>&1

echo Bootup $(date)
echo =================== ENV ===============
env
echo =================== ENV ===============

# Start services
for i in ${SERVICES}; do
    service "${i}" start
done

echo Done initializing $(date)
```

## Restart WSL
In **Windows**

```
wsl --shutdown
```

## Start it up
Restart WSL in your usual way.  Check ```/var/log/bootlog.*``` to ensure services started.

