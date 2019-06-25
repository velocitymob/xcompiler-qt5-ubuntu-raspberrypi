# download the image from docker
FROM ubuntu:18.04
# Author / Maintainer
MAINTAINER Giovanni Perez
#RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list
# Usage: ADD [source directory or URL] [destination directory]
# Installation of packages used for the compilation of Xcompiler and QT5
COPY sources.list /etc/apt/
ENV GCC_VERSION 7.3.1
ENV PATH_GCC /opt/gcc-linaro-${GCC_VERSION}
ENV ARCHCROSS arm-linux-gnueabihf-
ENV SYSROOT /mnt/raspbian/sysroot
RUN apt-get update && apt-get install -y \
build-essential \
libc6-dev \
wget \
curl \
gdb-multiarch \
xz-utils \
git \
unzip \
zip \
multistrap \
cmake \
python \
pkg-config \
&& rm -rf /var/lib/apt/lists/*
# WORKDIR used to change the working directory
RUN	mkdir -p /mnt/raspbian && mkdir -p ${PATH_GCC}
# Environment sysroot for compilation
COPY qt5pibuilder /opt/qt5pibuilder
WORKDIR /tmp

# download sysroot from google drive. TODO: find docker
RUN /bin/bash -c /opt/qt5pibuilder/getsysroot.sh
# download toolchain gcc linaro V7.3.1 TODO: add input to select the version and the compiler ..
RUN export var1=${PATH_GCC} && export var2=${GCC_VERSION} \
&& /bin/bash -c /opt/qt5pibuilder/getgcclinaro.sh -p $var1 -v $var2
RUN	printenv && echo "path:$$PATH_GCC ,version:$$GCC_VERSION"
WORKDIR /opt/qt5pibuilder
# compile qt5 for the target armv7l with sysroot and gcc-linaro-7.3.1
RUN /bin/bash -c ./build.sh
# show the compiled version
RUN /opt/qt5pibuilder/qt5/bin/qmake -query > /opt/reportfile.txt
