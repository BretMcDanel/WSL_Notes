## Backup WSL distribution
In **Windows** (cmd, powershell, terminal)  
```
wsl --terminate <desired distro>
wsl --export <desired distro> <backup path>\<distro name>.tar
```


## Restore or Clone distribition
In **Windows** (cmd, powershell, terminal)
```
wsl --import <distro name> <install-path> <temporary-path>\wsl2-usbip.tar
```
