#!/bin/sh


#SYSROOT_SD= /media/velo/9a7608bd-5bff-4dfc-ac1d-63a956744162mnt/
SYSROOT_SD= 
#PATHSYS='pi@192.168.178.53:'
PATHSYS=$SYSROOT_SD

if [ ! -d sysroot]; then 
	mkdir -p sysroot/usr
	mkdir -p sysroot/opt/vc
fi

rsync -avz $PATHSYS/lib sysroot
rsync -avz $PATHSYS/usr/include sysroot/usr
rsync -avz $PATHSYS/usr/lib sysroot/usr
rsync -avz $PATHSYS/opt/vc sysroot/opt
