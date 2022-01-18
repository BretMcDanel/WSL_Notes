# Introduction
These are some of my experiments with a LimeSDR USB in WSL under Windows 11.

# Environment
My current testbed environment (subject to change without notice)
* Windows 11 Pro Insider Preview build 22509
* WSL2g running Ubuntu 20.04
* LimeSDR USB connected via USB 3.x 
* [USBIPD-WIN](https://github.com/BretMcDanel/WSL_Notes/blob/main/Enable_USB.md) to provide USB access from within WSL
* Python 3.8.10
  * Where needed I prefer the apt packages for simplicity in lieu of pip modules.  This may cause some naming or path issues with pip modules

# Setup

## Install Lime Suite

This information is taken from https://wiki.myriadrf.org/Installing_Lime_Suite_on_Linux

```
sudo add-apt-repository -y ppa:myriadrf/drivers
sudo apt update
sudo apt install -y limesuite liblimesuite-dev limesuite-udev limesuite-images soapysdr soapysdr-module-lms7
```

## Configure UDEV

I utilize udev to ensure device permissions are appropriate.  In my test bed I grant all users access to the device though this may not be desireable in some environments.  I obtained this from https://github.com/myriadrf/LimeSuite/blob/master/udev-rules/64-limesuite.rules

Place the following contents in /etc/udev/rules.d/64-limesuite.rules

```
SUBSYSTEM=="usb", ATTR{idVendor}=="04b4", ATTR{idProduct}=="8613", SYMLINK+="stream-%k", MODE="666"
SUBSYSTEM=="usb", ATTR{idVendor}=="04b4", ATTR{idProduct}=="00f1", SYMLINK+="stream-%k", MODE="666"
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="601f", SYMLINK+="stream-%k", MODE="666"
SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6108", SYMLINK+="stream-%k", MODE="666"
SUBSYSTEM=="xillybus", MODE="666", OPTIONS="last_rule"

SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", SYMLINK+="serial"
```

## Connect Radio

I use the [usb_connect.sh](https://github.com/BretMcDanel/WSL_Notes/blob/main/scripts/usb_connect.sh) script I wrote which starts udev and other things as well as binding the device in USBIPD-WIN.  


## Testing the radio

First make sure the device can be detected

```
LimeUtil --find
```

You should get a response that tells you the device connection properties and the serial number.

Update firmware and gateware

```
LimeUtil --update
```

Now you can run a test.  Nothing should be connected to the RF ports.

```
LimeQuickTest
```

