#!/bin/sh -e
set -x
FILE=$1


if [  -d $FILE ]; then
	zip -r $FILE.zip $FILE
fi
