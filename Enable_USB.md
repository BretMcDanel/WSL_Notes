# WSL-USB-Connect
Connect USB devices from inside Linux in WSL.  This is a convenience script only and adds no functionality to directly running USBIPD from a Windows cmd shell.  I find it easier to launch an xterm and work there rather than first a Windows shell then my xterm.

# Dependencies
[usbipd](https://github.com/dorssel/usbipd-win/releases) must be installed in windows.

In WSL you need a couple tools (Ubuntu in my instance, non-Debian based will have to alter this command)

```sudo apt update && sudo apt -y install linux-tools-5.4.0-77-generic hwdata```

# Explanation
[This script](blob/main/scripts/usb_connect.sh) calls powershell.exe to invoke usbipd on the Windows side and attach the USB device specified in the script.

Where required powershell is invoked requesting Administrator permissions.  This causes a UAC popup to appear.  Attaching, Detaching or starting the USBIPD service all require administrator privileges.

# How to
You need to locate the USB device name.

```
usbipd list
```

In my case I see

```
BUSID  DEVICE                                                        STATE
1-4    LimeSDR-USB                                                   Not shared
1-3    Bulk-In, Interface                                            Not shared
```

If I want my LimeSDR I will use "LimeSDR-USB" alternatively if I want my RTL-SDR I will choose "Bulk-In, Interface"

## Connect

```
usb_connect.sh connect LimeSDR-USB
```
## Disconnect

```
usb_connect.sh disconnect LimeSDR-USB
```
## Reconnect (disconnects then reconnects)

```
usb_connect.sh reconnect LimeSDR-USB
```
