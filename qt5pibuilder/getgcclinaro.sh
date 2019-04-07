#!/bin/bash 
set -x
unset   my_gcc_VERSION  dst_path_GCC
# Defaults Values:

usage()
{
  echo "Usage: $0 [ -v GCC_VERSION ] [ -p GCC_PATH ] [-h|-r] "
  exit 2
}

set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo "Error: $varname already set"
    usage
  fi
}


while getopts 'v:p:?h' option
do
	case "${option}" in
		v)set_variable 	my_gcc_VERSION ${OPTARG}
			echo $my_gcc_VERSION
			;;
		p) set_variable dst_path_GCC ${OPTARG}
			echo $dst_path_GCC
			;;
		h|?) usage ;;
	esac	
done

echo "path: $dst_path_GCC , version: $my_gcc_VERSION"

if [[ -z "$dst_path_GCC" || -z "$my_gcc_VERSION" ]]; then
	dst_path_GCC=/opt/gcc-linaro-7.3.1
	my_gcc_VERSION=7.3.1
fi

#wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-$my_gcc_VERSION-2018.05-x86_64_arm-linux-gnueabihf.tar.xz  -O gcc-linaro-$my_gcc_VERSION.tar.xz
#tar -kx --xz -f gcc-linaro-$my_gcc_VERSION.tar.xz
#mv  gcc-linaro-*  $dst_path_GCC 
#rm -rf *.tar.*   

