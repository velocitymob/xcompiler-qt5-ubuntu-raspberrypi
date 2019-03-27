#!/bin/sh -e
set -x
USAGE="$(basename "$0") [-p] [-v]  -- install gcc-linaro-toolchain from https://releases.linaro.org/components/toolchain/binaries/

where:
	-h|--help help show this help text
	-p|--path path where you will storage the downllad, Default /opt/gcc-linaro-7.3.1
	-v|--version selected version available in the website, Default 7.3-2018.05 
"
while [ $# -gt 0 ]; do 
	key="$1"
	case $key in
		-h|--help)
			echo "$USAGE"
			exit
			;;
		-p|--path)
			PATH_GCC=$1
			shift
			echo "$USAGE"
			;;
		-v|--version)
			GCC_VERSION=$2
			;;	
	esac	
done


wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz -P $PATH_GCC -O gcc-linaro-$GCC_VERSION.tar.xz
tar -kx --xz -f gcc-linaro-$GCC_VERSION.tar.xz
mv  gcc-linaro-7.3.1-2018*  $PATH_GCC 
rm -rf *.tar.*   
