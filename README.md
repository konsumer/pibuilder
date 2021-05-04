# pibuilder

A docker-based chroot for building deb files

## usage

There are 2 dirs built-in:

- `/pi` a place to chroot to in your scripts that has a pi-build environment
- `/work` - volume-mount this to share scripts & output with the container

**Example**

Make a file called `buildsdl.sh` in current dir:
```sh
#!/bin/bash

# this will build pi framebuffer optimized SDL

mkdir -p /pi/work/out
cd /pi/work/out
wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz
tar -xvzf SDL2-2.0.14.tar.gz

cat << EOF | chroot /pi
apt update
apt build-dep -y libsdl2
cd /work/out/SDL2-2.0.14
DEB_CONFIGURE_EXTRA_FLAGS="--enable-video-kmsdrm --host=armv7l-raspberry-linux-gnueabihf --disable-pulseaudio --disable-esd --disable-video-mir --disable-video-wayland --disable-video-x11 --disable-video-opengl" dpkg-buildpackage -us -uc -j4
EOF
```

```sh
chmod +x buildsdl.sh
docker run -v ${PWD}:/pi/work --rm -it konsumer/pibuilder /pi/work/buildsdl.sh
```

## notes

I publish like this:

```sh
docker build -t konsumer/pibuilder .
docker push konsumer/pibuilder
```
