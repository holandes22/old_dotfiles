#!/bin/bash

set -e

ACTION=configure
USERNAME=pablo
HOSTNAME=laptop-$USERNAME
VIDEO_PACKAGES=mesa
SYSLINUX_CFG_FILE=/boot/syslinux/syslinux.cfg
LANG_CODE=en_US.UTF-8


configure() {
    systemctl start dhcpcd.service
    sleep 10
    pacman -S --noconfirm gnome $VIDEO_PACKAGES sudo xorg-server xorg-server-utils xorg-xinit alsa-utils
    for SN in gdm NetworkManager; do
        systemctl enable $SN.service
    done
    cp /etc/sudoers /etc/sudoers.original
    sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
}


install_chroot() {
    echo setting root passwd
    passwd

    echo Adding user $USERNAME
    useradd -m -g users -G lp,wheel,network,video,audio,storage -s /bin/bash $USERNAME
    passwd $USERNAME

    echo Setting locale and timezone
    sed -i "/^#$LANG_CODE\sUTF-8/s/^#//g" /etc/locale.gen
    locale-gen
    echo LANG=$LANG_CODE > /etc/locale.conf
    export LANG=$LANG_CODE
    ln -s /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
    echo $HOSTNAME > /etc/hostname

    # After linux kernerl 3.17-2 and 3.14.21-2 LTS, adding intel-ucode
    # img is needed at boot to enable microcode update
    pacman -S --noconfirm intel-ucode gptfdisk syslinux
    echo Adding intel-ucode boot images
    syslinux-install_update -iam
    for image in initramfs-linux initramfs-linux-fallback; do
        sed -i "s/INITRD\s..\/$image.img/INITRD ..\/intel-ucode.img,..\/$image.img/g" $SYSLINUX_CFG_FILE
    done
    sed -i "s/APPEND\sroot=\/dev\/sda3\srw/APPEND root=\/dev\/sda1 rw/g" $SYSLINUX_CFG_FILE
}

install() {
    echo Creating partitions
    echo "g
    n



    w" | fdisk /dev/sda

    mkfs.ext4 /dev/sda1
    mount /dev/sda1 /mnt
    echo Running pacstrap
    pacstrap /mnt base
    genfstab -U -p /mnt >> /mnt/etc/fstab
    echo "Running arch-chroot"
    cp ./install.sh /mnt/usr/src/

    arch-chroot /mnt /usr/src/install.sh -a install-chroot -n $HOSTNAME
    echo Done running arch-root
    mv /mnt/usr/src/install.sh /mnt/home/$USERNAME
    chmod 777 /mnt/home/$USERNAME/install.sh
    umount -R /mnt
}

usage() {
    echo "
    $0 [OPTIONS]

    options:

        -a Action to take [install|configure]
        -m Graphic card package
        -n hostname
        -h Display this message.

    "
    exit 1
}

while getopts "hm:n:a:" opt; do
  case $opt in
    m)
      echo "Using graphic cards $OPTARG" >&2
      if [ "$OPTARG" = "nvidia" ]; then
        VIDEO_PACKAGES=nvidia
      fi
      ;;
    n)
      echo "Hostname $OPTARG" >&2
      HOSTNAME=$OPTARG
      ;;
    a)
      echo "Running action $OPTARG" >&2
      ACTION=$OPTARG
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done


if [ "$ACTION" = "install" ]; then
    install
    echo Done. Now reboot and run configuration with /home/$USERNAME/install sh -a configure
elif [ "$ACTION" = "install-chroot" ]; then
    install_chroot
else
    configure
    echo Done configuring
fi
