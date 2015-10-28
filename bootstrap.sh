#!/bin/sh
set -e

SRC_SSH_DIR=ssh
TGT_SSH_DIR=$HOME/.ssh
PLAYBOOK=site.yml

while getopts "t:s:" opt; do
  case $opt in
    t)
      if [ "$OPTARG" = "gaming" ]; then
        PLAYBOOK=gaming.yml
      fi
      ;;
    s)
      SRC_SSH_DIR=$OPTARG
      ;;
  esac
done

echo Bootstrapping $PLAYBOOK

if [ ! -d "$TGT_SSH_DIR" ]; then
    mkdir $TGT_SSH_DIR
    cp -r $SRC_SSH_DIR/* $TGT_SSH_DIR
    chmod 400 $TGT_SSH_DIR/*
fi

is_installed() {
    which $1
    return $?

}

is_arch_pkg_installed() {
    pacman -Q $1 > /dev/null 2>&1
    return $?
}

install_packer() {
    if is_arch_pkg_installed packer; then
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
    for pkg in python2 python-pip openssh curl jshon expac git base-devel; do
        if is_arch_pkg_installed $pkg; then
            echo Package $pkg already installed
        else
            sudo pacman -S --noconfirm --needed $pkg
        fi
    done
}


get_and_install_pip() {
    curl -L https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    for n in 2 3; do
        if is_installed "pip$n"; then
            echo "pip$n" already installed
        else
            python$n /tmp/get-pip.py
        fi
    done
}

install_ubuntu_packages() {
    sudo apt-get update
    sudo apt-get install --yes git python-dev curl
}


if [ -e "/etc/arch-release" ]; then
    install_arch_packages
    install_packer
elif [ -e "/etc/lsb-release" ]; then
    install_ubuntu_packages
    get_and_install_pip
else
    echo "No need to install deps"
fi

cd $HOME
if [ ! -d dotfiles ]; then
    git clone git@github.com:holandes22/dotfiles
fi

sudo pip install virtualenv
virtualenv -p /usr/bin/python2 /tmp/.venv
/tmp/.venv/bin/pip install ansible
sudo ANSIBLE_CONFIG="$HOME/dotfiles/ansible.cfg" /tmp/.venv/bin/ansible-playbook -i dotfiles/provisioning/inventory dotfiles/provisioning/$PLAYBOOK -e ansible_python_interpreter=/usr/bin/python2
echo Done. Recommended to reboot
