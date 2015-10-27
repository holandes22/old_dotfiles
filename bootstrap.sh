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


is_installed() {
    pacman -Q $1 > /dev/null 2>&1
    return $?
}

install_packer() {
    if is_installed packer; then
        echo Packer already installed
    else
        echo Installing packer
        cd /tmp
        curl https://aur4.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer --output PKGBUILD
        makepkg -f
        sudo pacman -U --noconfirm packer-*.pkg.tar.xz
        cd -
    fi
}


install_arch_packages() {
    for pkg in python2 python-pip curl jshon expac git base-devel; do
        if is_installed $pkg; then
            echo Package $pkg already installed
        else
            sudo pacman -S --noconfirm --needed $pkg
        fi
    done
}

if [ -e "/etc/arch-release" ]; then
    install_arch_packages
    install_packer
elif [ -e "/etc/redhat-release" ]; then
    echo "No need to install deps"
else
    sudo apt-get update
    sudo apt-get install --yes git
fi

cd $HOME
if [ ! -d dotfiles ]; then
    git clone git@github.com:holandes22/dotfiles
fi

sudo pip install virtualenv
virtualenv -p /usr/bin/python2 /tmp/.venv
/tmp/.venv/bin/pip install ansible
sudo ANSIBLE_CONFIG="$HOME/dotfiles/ansible.cfg" /tmp/.venv/bin/ansible-playbook -i dotfiles/provisioning/inventory dotfiles/provisioning/site.yml -e ansible_python_interpreter=/usr/bin/python2

echo Done. Recommended to reboot
