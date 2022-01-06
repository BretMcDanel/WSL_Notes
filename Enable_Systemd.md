# Enable Systemd on Boot

By default WSL does not start systemd.

## The Script
Github user [diddledani](https://github.com/diddledani) has a [repository](https://github.com/diddledani/one-script-wsl2-systemd) that contains two scripts we need (and other stuff).

```
sudo wget 'https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/main/src/00-wsl2-systemd.sh' -O /etc/profile.d/00-wsl2-systemd.sh
sudo wget 'https://raw.githubusercontent.com/diddledani/one-script-wsl2-systemd/main/src/sudoers' -O /etc/sudoers.d/systemd
sudo chmod 440 /etc/sudoers.d/systemd
```

## Restart WSL
In **Windows**

```
wsl --shutdown
```

## Start it up
Restart WSL in your usual way and it should start systemd and all of the enabled services.

## Issues
* /tmp/.X11-unix should be a symlink to /mnt/wslg/.X11-unix but that sometimes gets wiped
* I start everything with an xterm shortcut on my Windows task bar, so I never do a "login"
** C:\Windows\System32\wsl.exe xfce4-terminal --working-directory $HOME
** I had to add the following to my .bashrc as a result
```
if [ -z "$(pidof /usr/bin/systemd)" ]; then
    exec sudo /bin/sh /etc/profile.d/00-wsl2-systemd.sh
fi
```
