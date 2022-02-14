# Introduction
Docker containers will not allow X and sound under the default environment.  

# WSLg X and Pulseaudio
WSLg mounts a virtual filesystem which contains the necessary hooks for X11 and pulseaudio functionality.  This directory, /mnt/wslg, and a few environment variables should be exported if you need that functionality.

***WAYLAND_DISPLAY***  
This lets Wayland clients know which Wayland compositor to connect to.

***XDG_RUNTIME_DIR***  
This is the directory where the Wayland display socket is created.

***DISPLAY***  
This is the X display to connect to

***PULSE_SERVER***  
This tells applications where the Pulseaudio server is.

# The Script
I place this in ~/.bashrc
```
# IS_WSL is legacy and probably depricated on any WSLg install                                                         
# WSL_DISTRO_NAME contains the current distro name (eg Ubuntu) 
if [ -n "$IS_WSL" ] || [ -n "$WSL_DISTRO_NAME" ]; then
    wsl_docker_args=""

    ## Build the args to use
    if [ -d /mnt/wslg ]; then
        wsl_docker_args="${wsl_docker_args} -v /mnt/wslg:/mnt/wslg"
    fi

    for var in WAYLAND_DISPLAY XDG_RUNTIME_DIR PULSE_SERVER DISPLAY; do
        if [ -n "${!var}" ]; then
            wsl_docker_args="${wsl_docker_args} -e $var"
        fi
    done
fi
```

Anytime I need to run a docker container I then add the variables
```
docker run ${wsl_docker_args} ...
```

# Docker-compose
Docker-compose can be used easily enough.

## wsl.env file
```
WAYLAND_DISPLAY=$WAYLAND_DISPLAY
XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
PULSE_SERVER=$PULSE_SERVER
DISPLAY=$DISPLAY
```

In your compose file
```
services:
  my-service:
    env_file:
      - wsl.env
    volumes:
      - /mnt/wslg:/mnt/wslg
```



