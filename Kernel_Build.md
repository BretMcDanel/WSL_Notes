# Build WSL kernel
Note: All distributions use the same kernel.  This can cause problems if you do not have the same tools in every system (eg usbip tools).  

## Environment
Some commands may need to be tweaked in other distributions  
WSL 2  
Ubuntu 20.04.3 LTS  

## Backup WSL distribution (Optional)
Instructions to [Backup and Clone](Backup_Clone.md) WSL Distribution

## Get the kernel source
In **WSL** (bash)  
```
# Update
sudo apt update
# Upgrade
sudo apt upgrade
# Install Prerequisites
sudo apt install build-essential flex bison libssl-dev libelf-dev libncurses-dev autoconf libudev-dev libtool
# Get kernel source
mkdir -p ~/src
cd ~/src
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
cd WSL2-Linux-Kernel
# Checkout current kernel branch
git checkout linux-msft-wsl-$(uname -r | sed -e 's/\([0-9.]*\)-.*/\1/')
zcat /proc/config.gz > .config
```

## Optional: Change options
Eg. [Enable USB](Kernel_Enable_USB.md)

## Build the kernel
Compile the kernel  
``` make -j $(getconf _NPROCESSORS_ONLN) && sudo make modules_install -j $(getconf _NPROCESSORS_ONLN) && sudo make install -j $(getconf _NPROCESSORS_ONLN)```


## Optional: Build USBIP tools  
```
cd tools/usb/usbip
./autogen.sh
./configure
sudo make install -j $(getconf _NPROCESSORS_ONLN)
```

## Install the kernel
Copy library so it can be used  
```sudo cp libsrc/.libs/libusbip.so.0 /lib/libusbip.so.0```

Install the kernel  
```cp arch/x86/boot/bzImage /mnt/c/Users/<user>/usbip-bzImage```

create or edit ```/mnt/c/Users/<user>/.wslconfig``` file with the following contents
[wsl2]
kernel=c:\\users\\<user>\\usbip-bzImage
  
In **Windows** restart WSL so it uses the new kernel  
```wsl --terminate```

Launch any instance and it will use the new kernel

## Optional 
Install USB IDs so names display  
```sudo apt install -y hwdata```

