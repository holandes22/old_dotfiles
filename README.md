# Arch install

    # curl -L bit.ly/pk-archinstall -o install.sh
    # ./install.sh -a install -n <hostname>

reboot and login as root

    # cd home/<username>
    # ./install.sh -a configure -v <video_drivers>

reboot

## If installing in virtualbox

Give 128MB of video memory and enable 3D acceleration.

Install VBox guest modules during install or configure phase.

    sudo pacman -S virtualbox-guest-modules-arch

If they are not loaded, then add the file `/etc/modules-load.d/vbox.conf` with
content

    vboxguest
    vboxsf
    vboxvideo

# Provision

**note:** Will ask for sudo and ssh passphrase at beginning, so stick around

    $ curl -L bit.ly/provision-bootstrap -o bootstrap.sh
    $ ./bootstrap.sh -s <ssh_dir>

reboot

