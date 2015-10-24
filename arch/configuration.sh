#!/bin/bash

set -e  # Abort on first error

HOSTNAME=laptop-pablo
LANG_CODE=en_US.UTF-8

sed -i '/$LANG_CODE UTF-8/s/^#//g' /etc/locale.gen
locale-gen
locale
echo LANG=$LANG_CODE > /etc/locale.conf
export LANG=$LANG_CODE
ln -s /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
echo $HOSTNAME > /etc/hostname

