# download the image from docker
FROM ubuntu:20.04
# Author / Maintainer
MAINTAINER Giovanni Perez
#RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list
# Usage: ADD [source directory or URL] [destination directory]
# Installation of packages used for the compilation of Xcompiler and QT5

COPY sources.list /etc/apt/ 
ARG QT_VERSION=5.13
ARG GCC_VERSION=7.3.1
ARG PATH_GCC=/opt/gcc-linaro-${GCC_VERSION}
ARG DEVICE=linux-rasp-pi3-g++
ARG SYSROOT=/mnt/raspbian/sysroot
ENV GCC_VERSION ${GCC_VERSION}
ENV PATH_GCC ${PATH_GCC}
ENV QT_VERSION ${QT_VERSION}

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

#WORKDIR /tmp 
# installing cmake for the future  
RUN /bin/bash /opt/qt5pibuilder/getcmake.sh 
	
# download sysroot from google drive.
RUN /bin/bash  /opt/qt5pibuilder/getsysroot.sh 

# download toolchain gcc linaro V7.3.1  TODO: add input to select the version and the compiler .. 
RUN echo "path: ${PATH_GCC}  Version: ${GCC_VERSION} " \
	&& /bin/bash /opt/qt5pibuilder/getgcclinaro.sh -v ${GCC_VERSION} -p ${PATH_GCC}

WORKDIR /opt/qt5pibuilder 
RUN printenv
# download toolchain gcc linaro V7.3.1  TODO: add input to select the version and the compiler .. 
#RUN printenv && /bin/bash /opt/qt5pibuilder/build.sh -c -d ${DEVICE} \\
	#	-gcc ${GCC_VERSION} -sys ${SYSROOT} -qt ${QT_VERSION} 

# show the compiled version
#RUN /opt/qt5pibuilder/qt5/bin/qmake -query > /opt/reportfile.txt
