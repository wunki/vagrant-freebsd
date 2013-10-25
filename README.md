# Freebsd on Vagrant

# Setup

This FreeBSD is build from the excellent [mfsBSD] ISO's. Installation is done
by booting the ISO and running the following:

    mount_cd9660 /dev/cd0 /cdrom
    zfsinstall -d /dev/ada0 -u /cdrom/9.2-RELEAE-amd64 -s 1G

After booting into the new installation, we can run the
`vagrant-installation.sh` script from this repository. This will install and
setup everything which is needed for Vagrant to run. First, login as root (no
password required).

Select your keyboard:

    kbdmap

Get an IP adress:

    dhclient vtnet0

In your FreeBSD box, fetch the installation script:

    fetch -o /tmp/freebsd-installation.sh https://raw.github.com/wunki/vagrant-freebsd/master/vagrant-installation.sh

Inside your FreeBSD VM, fetch the installation file.

    fetch http://<your-local-ip>:8080/vagrant-installation.sh
    chmod +x vagrant-installation.sh

Run it:

    ./vagrant-installation.sh

Reboot, possibly do some custom modifications and package the box by running
the following on your local machine:

    vagrant package --base <your-virtualbox> --output freebsd-92-amd64-wunki

[mfsBSD]: http://mfsbsd.vx.sk/
