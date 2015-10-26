#!/bin/sh
set -e
SRC_SSH_DIR=$1
TGT_SSH_DIR=$HOME/.ssh

mkdir $TGT_SSH_DIR
cp -r $SRC_SSH_DIR/* $TGT_SSH_DIR
chmod 400 $TGT_SSH_DIR/*

echo bootstrapping

if [ -e "/etc/arch-release" ]; then
    sudo pacman -Sy --noconfirm python2 python-pip curl base-devel fakeroot jshon expac git
    cd /tmp
    curl https://aur4.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer --output PKGBUILD
    makepkg -f
    sudo pacman -U --noconfirm packer-*.pkg.tar.xz
    cd -
elif [ -e "/etc/redhat-release" ]; then
    echo "No need to install deps"
else
    sudo apt-get update
    sudo apt-get install --yes git
fi

sudo pip install virtualenv
virtualenv -p /usr/bin/python2 /tmp/.venv
/tmp/.venv/bin/pip install ansible
/tmp/.venv/bin/ansible-playbook -i provisioning/inventory provisioning/site.yml -e ansible_python_interpreter=/usr/bin/python2
echo done. Recommended to reboot
