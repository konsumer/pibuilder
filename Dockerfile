# this has qemu & a raspbian chroot preinstalled

FROM debian AS pibuilder

RUN apt-get update && apt-get install -y git binfmt-support qemu qemu-user-static debootstrap wget dput
RUN wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -q && \
  mkdir /pi && \
  qemu-debootstrap --keyring=/etc/apt/trusted.gpg --arch armhf buster /pi http://mirrordirector.raspbian.org/raspbian/
RUN chroot /pi apt-get install -y build-essential debhelper autotools-dev automake libtool pkg-config

RUN cat /pi/etc/apt/sources.list |sed s/^deb/deb-src/ >> /pi/etc/apt/sources.list
RUN echo "nameserver 1.1.1.1" > /pi/etc/resolve.conf

VOLUME /work
WORKDIR /work
