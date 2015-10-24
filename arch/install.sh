#!/bin/bash

set -e  # Abort on first error

function usage()
{
cat <<-ENDOFMESSAGE

$0 [OPTIONS]

options:

    -m Model.
    -h Display this message.

ENDOFMESSAGE
exit 1
}

UNMUTE_CMD="amixer sset Master unmute"
VIDEO_PACKAGES=mesa

while getopts "hm:" opt; do
  case $opt in
    m)
      echo "Running model $OPTARG" >&2
      if [ "$OPTARG" = "x1" ]; then
        echo "systemctl enable dhcpcd.service"
        echo "systemctl start dhcpcd.service"
        # UNMUTE_CMD="amixer -c1 sset Master unmute"
      fi
      if [ "$OPTARG" = "desktop" ]; then
        echo "systemctl enable dhcpcd.service"
        echo "systemctl start dhcpcd.service"
        VIDEO_PACKAGES=nvidi
        # For nvidia choose nvidia-libgl
      fi
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done


pacman -S gnome $VIDEO_PACKAGES sudo xorg-server xorg-server-utils xorg-xinit alsa-utils ttf-dejavu

useradd -m -g users -G lp,wheel,network,video,audio,storage -s /bin/bash pablo
passwd pablo
$UNMUTE_CMD
#systemctl enable gdm.service
#systemctl enable NetworkManager.service
#systemctl enable sshd.service
