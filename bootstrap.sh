#!/bin/sh
set -e

SRC_SSH_DIR=$1
TGT_SSH_DIR=$HOME/.ssh

echo Bootstrapping

if [ ! -d "$TGT_SSH_DIR" ]; then
    mkdir $TGT_SSH_DIR
    cp -r $SRC_SSH_DIR/* $TGT_SSH_DIR
    chmod 400 $TGT_SSH_DIR/*
fi



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

cd $HOME
git clone git@github.com:holandes22/dotfiles
cd dotfiles

sudo pip install virtualenv
virtualenv -p /usr/bin/python2 /tmp/.venv
/tmp/.venv/bin/pip install ansible
sudo /tmp/.venv/bin/ansible-playbook -i provisioning/inventory provisioning/site.yml -e ansible_python_interpreter=/usr/bin/python2

cd $HOME
echo Done. Recommended to reboot
