# download the image from docker
FROM ubuntu:18.04
# Author / Maintainer
MAINTAINER Giovanni Perez
#RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list
# Usage: ADD [source directory or URL] [destination directory]
ARG GCC_VERSION=7.3.1
ARG PATH_GCC=/opt/gcc-linaro-${GCC_VERSION}
ENV ARCHCROSS arm-linux-gnueabihf-
ENV SYSROOT /mnt/raspbian/sysroot
ENV GCC_VERSION ${GCC_VERSION}
ENV PATH_GCC ${PATH_GCC}
# Installation of packages used for the compilation of Xcompiler and QT5
COPY sources.list /etc/apt/ 

RUN  printenv

RUN apt-get update && apt-get install -y \
	build-essential \
	libc6-dev\
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
#TODO: replace  RUN command by ADD. Files from remote URLs will untar the file into the ADD director

# installing cmake for the future  
RUN wget  https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1.tar.gz \
	&& tar -kx  -f cmake-3.14.1.tar.gz \
	&& rm -rf *.tar.* \
	&& mv cmake* /opt  \
  && cd /opt/cmake* && ./bootstrap && make && sudo make install  \ 
	&& cmake --version
	
	
# download sysroot from google drive. TODO: find docker 
RUN /bin/bash -c /opt/qt5pibuilder/getsysroot.sh 
# download toolchain gcc linaro V7.3.1  TODO: add input to select the version and the compiler .. 
WORKDIR /tmp 
RUN /bin/bash -c /opt/qt5pibuilder/getgcclinaro.sh 
WORKDIR /opt/qt5pibuilder
RUN ls -lah && pwd
# compile qt5 for the target armv7l with sysroot and gcc-linaro-7.3.1
RUN /bin/bash -c ./build.sh
# show the compiled version  
RUN /opt/qt5pibuilder/qt5/bin/qmake -query > reportfile.txt
