#!/bin/bash 
set -x
unset   my_gcc_VERSION  dst_path_GCC
# Defaults Values:

usage=" $(basename "$0") [ -v GCC_VERSION ] [ -p GCC_PATH ] [-h|-r] "
while [ $# -gt 0 ]  
do
	key="$1"
	case ${key} in
		-v|--version)
			my_gcc_VERSION=$2
			echo ${my_gcc_VERSION}
			shift
			shift
			;;
		-p|--path) 
		 	dst_path_GCC=$2
			echo ${dst_path_GCC}
			shift
			shift
			;;
		h|?) $usage ;;
	esac	
done

set -- "${usage[@]}" 

echo "path: ${dst_path_GCC} , version: ${my_gcc_VERSION}"

if [[ -z "${dst_path_GCC}" || -z "${my_gcc_VERSION}" ]]; then
	dst_path_GCC=/opt/gcc-linaro-7.3.1
	my_gcc_VERSION=7.3.1
fi

wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-${my_gcc_VERSION}-2018.05-x86_64_arm-linux-gnueabihf.tar.xz -P ${dst_path_GCC}  -O gcc-linaro-${my_gcc_VERSION}.tar.xz
tar -kx --xz -f gcc-linaro-${my_gcc_VERSION}.tar.xz
rm -rf *.tar.*   
mv  gcc-linaro-*  ${dst_path_GCC} 

