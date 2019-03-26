#!/bin/sh -e

set -x
wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz -P $PATH_GCC -O gcc-linaro-$GCC_VERSION.tar.xz
tar -kx --xz -f gcc-linaro-$GCC_VERSION.tar.xz
mv  gcc-linaro-7.3.1-2018*  $PATH_GCC 
rm -rf *.tar.*   
