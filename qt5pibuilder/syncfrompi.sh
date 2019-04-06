#!/bin/bash -e

set -x
#SYSROOT_SD= /media/velo/9a7608bd-5bff-4dfc-ac1d-63a956744162mnt/
SYSROOT_SD=$1 
PATHSYS='root@172.17.0.2:'
#PATHSYS=$SYSROOT_SD
__KEY=$2
ls -la
if [ ! -d $PWD/${SYSROOT_SD} ]; then 
	mkdir -p sysroot/usr
	mkdir -p sysroot/opt/vc
fi

echo ${PATHSYS} ${__KEY}
rsync -avz -e "ssh -i ${__KEY}" $PATHSYS/lib sysroot
rsync -avz -e "ssh -i ${__KEY}" $PATHSYS/usr/include sysroot/usr
rsync -avz -e "ssh -i ${__KEY}" $PATHSYS/usr/lib sysroot/usr
rsync -avz -e "ssh -i ${__KEY}" $PATHSYS/opt/vc sysroot/opt
