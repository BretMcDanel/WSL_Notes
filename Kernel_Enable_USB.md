# Enable USB in a kernel build
This is executed just prior to building the kernel.  See (Kernel Building)[Kernel_Build.md) for the instructions before and after that are required.

```
# Make sure CONFIG_USB=y 
sed -i 's/CONFIG_USB=./CONFIG_USB=y/' .config
```

Make sure all options you want are selected (Debugging was the only thing not enabled)  
``` make menuconfig ```  
Device Drivers -> USB Support  
Device Drivers -> USB Support -> USB announce new devices  
Device Drivers -> USB Support -> USB Modem (CDC ACM) support  
Device Drivers -> USB Support -> USB/IP  
Device Drivers -> USB Support -> USB/IP -> VHCI HCD  
Device Drivers -> USB Support -> USB/IP -> Debug messages for USB/IP  
Device Drivers -> USB Serial Converter Support  
Device Drivers -> USB Serial Converter Support -> USB FTDI Single port Serial Driver  
