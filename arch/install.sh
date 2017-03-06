#!/bin/bash

set -e

ACTION=configure
USERNAME=pablo
HOSTNAME=laptop-$USERNAME
VIDEO_PACKAGES=mesa
SYSLINUX_CFG_FILE=/boot/syslinux/syslinux.cfg
LANG_CODE=en_US.UTF-8
DEVICE=/dev/sda
LOCALTIME=Asia/Jerusalem


configure() {
    echo Starting dhcpcd service...
    systemctl start dhcpcd.service
    sleep 10
    echo Installing packages
    pacman -S --noconfirm gnome $VIDEO_PACKAGES sudo xorg-server xorg-server-utils xorg-xinit alsa-utils
    for svcname in gdm NetworkManager; do
        systemctl enable $svcname.service
    done
    cp /etc/sudoers /etc/sudoers.original
    sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
}


create_users() {
    echo setting root passwd
    passwd

    echo Adding user $USERNAME
    useradd -m -g users -G lp,wheel,network,video,audio,storage -s /bin/bash $USERNAME
    passwd $USERNAME
}

set_time_and_locale()  {
    sed -i "/^#$LANG_CODE\sUTF-8/s/^#//g" /etc/locale.gen
    locale-gen
    echo LANG=$LANG_CODE > /etc/locale.conf
    export LANG=$LANG_CODE
    ln -sf /usr/share/zoneinfo/$LOCALTIME /etc/localtime
}

create_partitions() {
    echo "g
    n



    w" | fdisk $DEVICE

    mkfs.ext4 -O "^64bit" $DEVICE\1
}


install_chroot() {
    echo Setting users
    create_user

    echo Setting locale and timezone
    set_time_and_locale
    echo $HOSTNAME > /etc/hostname

    # After linux kernerl 3.17-2 and 3.14.21-2 LTS, adding intel-ucode
    # img is needed at boot to enable microcode update
    echo Adding intel-ucode boot images
    pacman -S --noconfirm intel-ucode gptfdisk syslinux
    syslinux-install_update -iam
    for image in initramfs-linux initramfs-linux-fallback; do
        sed -i "s/INITRD\s..\/$image.img/INITRD ..\/intel-ucode.img,..\/$image.img/g" $SYSLINUX_CFG_FILE
    done
    sed -i "s:APPEND\sroot=/dev/sda3\srw:APPEND root=${DEVICE}1 rw:g" $SYSLINUX_CFG_FILE
}

install() {
    echo Creating partitions
    create_partitions

    mount $DEVICE\1 /mnt

    echo Running pacstrap
    pacstrap /mnt base
    genfstab -U -p /mnt >> /mnt/etc/fstab

    echo Running arch-chroot
    cp ./install.sh /mnt/usr/src/
    arch-chroot /mnt /usr/src/install.sh -a install-chroot -n $HOSTNAME

    echo Finalizing
    mv /mnt/usr/src/install.sh /mnt/home/$USERNAME
    chmod 777 /mnt/home/$USERNAME/install.sh
    umount -R /mnt
}

usage() {
    echo "
    $0 [OPTIONS]

    options:

        -a Action to take [install|configure]
        -h Display this message.

    install options:

        -n Hostname
        -d Disk device (default: $DEVICE)

    configure options:

      -v Graphic card package [nvidia|mesa] (default: $VIDEO_PACKAGES)


    "
    exit 1
}

while getopts "hv:n:a:d:" opt; do
  case $opt in
    v)
      if [ "$OPTARG" = "nvidia" ]; then
        VIDEO_PACKAGES=nvidia
      fi
      ;;
    n)
      HOSTNAME=$OPTARG
      ;;
    a)
      ACTION=$OPTARG
      ;;
    d)
      DEVICE=$OPTARG
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done


echo running action $ACTION

if [ "$ACTION" = "install" ]; then

    echo hostname is $HOSTNAME
    echo device is $DEVICE
    echo video packages are $VIDEO_PACKAGES
    echo is the above info correct? [y/n]
    read -t 10 confirm

    if [ "$confirm" = 'y' ]; then
        echo Ok, we move on
        install
        echo Done. Now reboot and run configuration with /home/$USERNAME/install sh -a configure
    else
        echo We done here
        exit
    fi

elif [ "$ACTION" = "install-chroot" ]; then
    install_chroot

elif [ "$ACTION" = "configure" ]; then
    configure
    echo Done configuring. Please reboot.

else
    echo Please specify an action
    exit 1
fi
