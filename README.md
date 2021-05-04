# pibuilder

A docker-based chroot for building deb files

## usage

There are 2 dirs built-in:

- `/pi` a plce to chroot to in your scripts that has a pi-build environment
- `/work` - volume-mount this to share scripts & output with the container

**Example**

Make a file called `buildsdl.sh` in current dir:
```sh
#!/bin/bash

cd /tmp
apt build-dep -y libsdl2 && \
apt install -y --no-install-recommends libdrm-dev libgbm-dev libsamplerate-dev libudev-dev dh-autoreconf fcitx-libs-dev libasound2-dev libgl1-mesa-dev libpulse-dev libdbus-1-dev libibus-1.0-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxrandr-dev libxss-dev libxxf86vm-dev && \
wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz && \
tar -xvzf SDL2-2.0.14.tar.gz && \
cd SDL2-2.0.14
DEB_CONFIGURE_EXTRA_FLAGS="--enable-video-kmsdrm" dpkg-buildpackage -us -uc -j4
mkdir -p /work/out
mv /tmp/libsdl*.deb /work/out
```

```sh
docker run -v ${PWD}:/work --rm -it konsumer/pibuilder chroot /pi /work/buildsdl.sh
```

## notes

I publish like this:

```sh
docker build -t konsumer/pibuilder .
docker push konsumer/pibuilder
```
