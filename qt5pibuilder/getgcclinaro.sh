#!/bin/sh -e
set -x
# Defaults Values:

USAGE="$(basename "$0") [-h] PATH_GCC GCC_VERSION -- install gcc-linaro-toolchain from https://releases.linaro.org/components/toolchain/binaries/

where:
	-h|--help help show this help text
"
while [ $# -gt 0 ]; do 
	case $key in
		-h|--help)
			echo "$USAGE"
			exit
			;;
		*)
			echo "$USAGE"
			shift
			;;
	esac	
done
wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz  -O gcc-linaro-$GCC_VERSION.tar.xz
tar -kx --xz -f gcc-linaro-$GCC_VERSION.tar.xz
mv  gcc-linaro-7.3.1-*  $PATH_GCC 
rm -rf *.tar.*   
