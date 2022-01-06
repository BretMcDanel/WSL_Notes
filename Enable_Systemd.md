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

