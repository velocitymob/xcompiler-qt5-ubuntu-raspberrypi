#!/bin/sh -e

set -x

SAVE_COOKIES=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1rsX8h1eSGwRehzPLj-u7aFtsmbpqdrDQ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p') 

echo ${SAVE_COOKIES}
wget --load-cookies \
 	/tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${SAVE_COOKIES}&id=1rsX8h1eSGwRehzPLj-u7aFtsmbpqdrDQ" -O sysroot.tar.xz && rm -rf /tmp/cookies.txt 
ls -lah 
rm -rf /tmp/cookies.txt 
tar -kx --xz -f sysroot.tar.xz 
mv rpiSys*/sysroot /mnt/raspbian/ 
rm -rf rpiSys* 
rm -rf *.tar.* 
pwd

