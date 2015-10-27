# Arch install

    # curl -L bit.ly/pk-archinstall -o install.sh
    # chmod 777 install.sh
    # ./install.sh -a install -n <hostname>

reboot

    # cd home/<username>
    # ./install.sh -a configure

reboot

## If installing in virtualbox

Give 128MB of video memory and enable 3D acceleration
sudo pacman -S virtualbox-guest-utils
sudo vim /etc/modules-load.d/vbox.conf
vboxguest
vboxsf
vboxvideo

# Provision

**note:** Will ask for sudo and ssh passphrase at beginning, so stick around

    $ curl -L bit.ly/provision-bootstrap -o bootstrap.sh
    $ chmod 777 bootstrap.sh
    $ ./bootstrap.sh <ssh_dir>

reboot

