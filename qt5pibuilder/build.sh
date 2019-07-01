#!/bin/sh 

# show in wich line is run the code
set -x
set -e
unset QT_VERSION GCC_VERSION PATH_GCC

#this giy need to be a variable in the future
#QT_VERSION=5.9
# here come wich gcc tool do you want to try
#GCC_VERSION=7.3.1
# SYSROOT=/mnt/raspbian/sysroot
# module used to compile Stationpedelec, in the future add qtweb
ARCHCROSS=arm-linux-gnueabihf-
#QT_MODULES="qtxmlpatterns qtdeclarative qtserialport qtquickcontrols"
QT_MODULES=""
BASEDIR=$PWD
CLEAN=true
# here you can use a frisch raspbian image or your personal sysroot
# DEVICE="linux-rasp-pi3-g++"
# DEVICE='linux-rasp-pi3-vc4-g++'
MAKE_OPTS=-j$( nproc)
USAGE="$(basename "$0") [-c] [-d device] [-gcc GCC_VERSION] [-sys SYSROOT_PATH ] [-qt QT_VERSION] [-h]-- install toolchain and build qt5 for raspberry pi, automated version of https://wiki.qt.io/RaspberryPi2EGLFS

where:
	-c|--clean	clean all modules to force rebuild
	-d|--device	build for a specific device (defaults to linux-rpi3-g++)
	-gcc|--gcc-linaro-version	select the crosscompiler from linaro bianrie
	-sys|--sysroot select sysroot from server or build a new one
	-qt|--qt-version select the version to compile of qt
	-h|--help	show this help text
	"
while [ $# -gt 0 ]
do
	key="$1"
	case $key in
		-c|--clean)
		CLEAN=true
		shift
		;;
		-d|--device)
		DEVICE=$2
		shift
		shift
		;;
		-gcc|--gcc-linaro-version)
		GCC_VERSION=$2
		echo "${GCC_VERSION}"
		shift
		shift
		;;
		-sys|--sysroot)
		SYSROOT=$2
		echo "${SYSROOT}"
		shift
		shift
		;;
		-qt|--qt-version)
		QT_VERSION=$2
		echo "${QT_VERSION}"
		shift
		shift
		;;
		-h|*)
		echo "${USAGE}"
		exit 
		;;
	esac
done
set -- "${USAGE[@]}" # restore positional parameters

echo "-c:${CLEAN} -d:${DEVICE} -gcc:${GCC_VERSION} -sys:${SYSROOT} -qt:${QT_VERSION}"
# get compiler
PATH_GCC=/opt/gcc-linaro-${GCC_VERSION}
COMPILER=${PATH_GCC}/gcc-linaro-${GCC_VERSION}-2018.05-x86_64_arm-linux-gnueabihf/bin/${ARCHCROSS}

echo "GET COMPILER"
if [ ! -d ${PATH_GCC}/gcc-linaro-${GCC_VERSION}-2018.05-x86_64_arm-linux-gnueabihf]; then
	cd /tmp
	HTTP_LINARO="https://releases.linaro.org/components/toolchain/binaries/"
  #LINARO_TOOLCHAIN=$( curl -s $HTTP_LINARO  --list-only | sed -n  "/href/ s/.*href=['\"]\([^'\"]*\)['\"].*/\1/gp" | grep $GCC_VERSION )
	#curl -s $HTTP_LINARO$LINARO_TOOLCHAIN/arm-linux-gnueabihf/ --list-only >listtoolchain 
	/bin/bash  /${BASEDIR}/qt5pibuilder/getgcclinaro.sh ${PATH_GCC} ${GCC_VERSION}
	cd $BASEDIR
fi


echo "GET SYSROOT"
if [ -d $SYSROOT_PATH	]; then
	#TODO: mount  new image and install dependency to create a new sysroot_2019
	echo "Getting Sysroot from googledrive"
else
	echo "Getting Sysroot from scratch"
fi

cd $BASEDIR
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

cd ${BASEDIR}/qtbase
if [ "$CLEAN" = true ]; then
	git clean -d -f -x
fi

./configure -release \
	-opengl es2 -no-use-gold-linker \
  -device $DEVICE	-device-option CROSS_COMPILE=$COMPILER \
	-sysroot $SYSROOT -opensource -confirm-license -make libs -make tests -nomake examples \
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

	${BASEDIR}/qt5/bin/qmake
	make ${MAKE_OPTS}
	make install
	cd ..
done

zip -r qt5pibuilder.zip ${BASEDIR}/qt5
zip -r qt5pibuilder.zip ${BASEDIR}/qt5pi

echo "completed the work"
