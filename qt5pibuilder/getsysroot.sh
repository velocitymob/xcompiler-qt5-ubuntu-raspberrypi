#!/bin/sh -e

set -x

#SAVE_COOKIES=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1rsX8h1eSGwRehzPLj-u7aFtsmbpqdrDQ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p') 
SAVE_COOKIES=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/a/velocitymobility.com/uc?export=download&id=19erIv_lLexqFPera9TgNvIpvjSC0PSSu' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p') 

echo ${SAVE_COOKIES}
wget --load-cookies \
 	#/tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${SAVE_COOKIES}&id=1rsX8h1eSGwRehzPLj-u7aFtsmbpqdrDQ" -O sysroot.tar.xz && rm -rf /tmp/cookies.txt 
 	/tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=${SAVE_COOKIES}&id=19erIv_lLexqFPera9TgNvIpvjSC0PSSu" -O sysroot.tar.xz && rm -rf /tmp/cookies.txt 
ls -lah 
tar -kx --xz -f sysroot.tar.xz 
if [ ! -d /mnt/raspbian/sysroot ];then
	echo 'directory not founded'
	mkdir -p /mnt/raspbian
else
	echo 'directory founded'
fi

mv rpiSys*/sysroot /mnt/raspbian/ 
rm -rf rpiSys* 
rm -rf *.tar.* 
pwd
