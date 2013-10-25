# Freebsd on Vagrant

TODO: Introduction

**Table of Contents**

- [Freebsd on Vagrant](#freebsd-on-vagrant)
	- [Quickstart](#quickstart)
	- [Virtualbox settings](#virtualbox-settings)
	- [Build a Custom box](#build-a-custom-box)
	- [TODO's](#todo's)
	- [License](#license)

## Quickstart

Simply copy the Vargantfile from this repository to the project you want to
run the VM from and you are done. The box will be downloaded if it's not
avnailable for you.

## Virtualbox settings

Your virtualbox works best with the following settings:

- System -> Motherboard -> **Hardware clock in UTC time**
- System -> Acceleration -> **VT/x/AMD-V**
- System -> Acceleration -> **Enable Nested Paging**
- Storage -> Attach a **.vdi** disk (this one we can minimize later)
- Network -> Adapter 1 -> Advanced -> Adapter Type -> **Paravirtualized Network (virtio-net)**
- Network -> Adapter 2 -> Advanced -> Attached to -> **Host-Only Adapter**
- Network -> Adapter 2 -> Advanced -> Adapter Type -> **Paravirtualized Network (virtio-net)**

I would also recommend to disable all the things you are not using, such as
*audio* and *usb*.

## Build a Custom box

This FreeBSD is build from the excellent [mfsBSD] ISO's. Installation is done
by booting the [9.2-RELEASE-amd64 special edition] and running the following:

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

    fetch -o /tmp/vagrant-setup.sh https://raw.github.com/wunki/vagrant-freebsd/master/bin/vagrant-setup.sh

Inside your FreeBSD VM, fetch the installation file.

    fetch http://<your-local-ip>:8080/vagrant-installation.sh
    chmod +x vagrant-installation.sh

Run it:

    ./vagrant-installation.sh

Reboot, possibly do some custom modifications and package the box by running
the following on your local machine:

    vagrant package --base <your-virtualbox> --output freebsd-92-amd64-wunki


## TODO's

You can find the TODO's in the [TODO.org] at the root of this repository.

## License

The above is released under the BSD license, who would have thought! Meaning,
do whatever you want, but I would sure appreciate if you contribute any
improvements back to this repository.

[mfsBSD]: http://mfsbsd.vx.sk/
[9.2-RELEASE-amd64 special edition]: http://mfsbsd.vx.sk/
[TODO.org]: https://github.com/wunki/vagrant-freebsd/blob/master/TODO.org
