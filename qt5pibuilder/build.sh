#!/bin/sh -e

# show in wich line is run the code
set -x

#this giy need to be a variable in the future
QT_VERSION=5.10
# here come wich gcc tool do you want to try
GCC_VERSION=7.3.1
ARCHCROSS=arm-linux-gnueabihf-
PATH_GCC=/opt/gcc-linaro-$GCC_VERSION

# module used to compile Stationpedelec, in the future add qtweb
QT_MODULES="qtxmlpatterns qtdeclarative qtserialport qtquickcontrols"
BASEDIR=$PWD
CLEAN=true

# here you can use a frisch raspbian image or your personal sysroot
DEVICE="linux-rasp-pi3-g++"

# DEVICE='linux-rasp-pi3-vc4-g++'
SYSROOT=/mnt/raspbian/sysroot
COMPILER=$PATH_GCC/gcc-linaro-$GCC_VERSION-2018.05-x86_64_arm-linux-gnueabihf/bin/$ARCHCROSS

MAKE_OPTS=-j$( nproc)

USAGE="$(basename "$0") [-h] [-c] [-d device] -- install toolchain and build qt5 for raspberry pi, automated version of https://wiki.qt.io/RaspberryPi2EGLFS

where:
	-h|--help	show this help text
	-c|--clean	clean all modules to force rebuild
	-d|--device	build for a specific device (defaults to linux-rpi3-g++)
	-gcc|--gcc-linaro-version	select the crosscompiler from linaro bianrie
	-sys|--sysroot select sysroot from server or build a new one
	"

while [ $# -gt 0 ]; do
	key="$1"
		
	case $key in
		-c|--clean)
		CLEAN=true
		shift
		;;
		-d|--device)
		DEVICE="$4"
		shift
		shift
		;;
		-h|--help)
		echo "$USAGE"
		exit
		;;
		-gcc|--gcc-linaro-version)
		GCC_VERSION=$3
		echo "$USAGE"
		exit
		;;
		-sys|--sysroot)
		SYSROOT=$2
		echo "$USAGE"
		exit
		;;
	    	*)
		echo "$USAGE"
		exit
		;;
	esac
done

# get compiler
echo "GET COMPILER"
if [ ! -d $PATH_GCC/gcc-linaro-$GCC_VERSION-2018.05-x86_64_arm-linux-gnueabihf]; then
	cd /tmp
	HTTP_LINARO="https://releases.linaro.org/components/toolchain/binaries/"
  #LINARO_TOOLCHAIN=$( curl -s $HTTP_LINARO  --list-only | sed -n  "/href/ s/.*href=['\"]\([^'\"]*\)['\"].*/\1/gp" | grep $GCC_VERSION )
	#curl -s $HTTP_LINARO$LINARO_TOOLCHAIN/arm-linux-gnueabihf/ --list-only >listtoolchain 
	wget -c https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05\
			/arm-linux-gnueabihf/gcc-linaro-$GCC_VERSION-2018.05-x86_64_arm-linux-gnueabihf.tar.xz\
	 		-P $PATH_GCC -O gcc-linaro-$GCC_VERSION.tar.xz
	tar -kx --xz -f gcc-li*.tar.xz
  mv  gcc-linaro-$GCC_VERSION-2018*  $PATH_GCC
	rm -rf *.tar.*
	cd $BASEDIR
fi


echo "GET SYSROOT"
if [ "$OPTIONSYS" = "$SYSROOT" ]; then
	#TODO: mount  new image and install dependency to create a new sysroot_2019
	cd /tmp
	wget -c https://downloads.raspberrypi.org/raspbian_latest -o raspbian.zip
	unzip raspbian.zip -d /tmp/mysysroot_$(date -u "+%Y.%m.%d-%T")
  set SYSROOT=$PWD	
	cd $BASEDIR
else
	echo "Getting Sysroot from googledrive"
	cd $BASEDIR

	#  curl -JLO  "https://www.dropbox.com/s/4nm8saa2snh8un4/rpiSysroot-2018-06-27-raspbian-stretch-lite-updated.tar.xz?dl=0"

fi

# clean old build
if [ "$CLEAN" = true ]; then
	rm -rf $BASEDIR/qt5 $BASEDIR/qt5pi
fi

if [ ! -f sysroot-relativelinks.py ]; then
	wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
	chmod +x sysroot-relativelinks.py
  ./sysroot-relativelinks.py $SYSROOT
fi
./sysroot-relativelinks.py $SYSROOT

# build qtcore
if [ ! -d qtbase ]; then
	git clone --depth 1 git://code.qt.io/qt/qtbase.git -b $QT_VERSION
fi

cd qtbase
if [ "$CLEAN" = true ]; then
	git clean -d -f -x
fi

./configure -release -opengl es2 -device $DEVICE  -no-use-gold-linker \
-device-option CROSS_COMPILE=$COMPILER \
-sysroot $SYSROOT -opensource -confirm-license -make libs \
-prefix /usr/local/qt5pi -extprefix $BASEDIR/qt5pi -hostprefix $BASEDIR/qt5 -v
make ${MAKE_OPTS}
make install
cd ..

# build qt modules
for MODULE in $QT_MODULES; do
	if [ ! -d $MODULE ]; then
		git clone --depth 1 git://code.qt.io/qt/$MODULE.git -b $QT_VERSION
	fi
	echo entering $MODULE
	cd $MODULE
	if [ "$CLEAN" = true ]; then
		git clean -d -f -x
	fi
	$BASEDIR/qt5/bin/qmake
	make ${MAKE_OPTS}
	make install
	cd ..
done

echo completed the work
