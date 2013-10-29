# Freebsd on Vagrant

<img src="https://wunki.org/images/freebsd-icon.png" align="right" />

> Quidquid latine dictum sit, altum viditur.
> 
> _(Whatever is said in Latin sounds profound.)_

I love [FreeBSD] but it's a lot of work to get it running correctly on
[Vagrant]. That's a shame, because more people should experience the quality of
FreeBSD, the convenience of [jails] and a modern filesystem like [ZFS].

Well, now you can! With this Vagrant box you get a fully tuned, latest FreeBSD
with ZFS by copying a single file.

**Table of Contents**

- [Freebsd on Vagrant](#freebsd-on-vagrant)
	- [Quickstart](#quickstart)
	- [Create your own FreeBSD Box](#create-your-own-freebsd-box)
		- [Virtualbox Settings](#virtualbox-settings)
		- [Installation from msfBSD ISO](#installation-from-msfbsd-iso)
		- [Configuration](#configuration)
		- [Package for Vagrant](#package-for-vagrant)
	- [What's Next?](#what's-next)
	- [Credits](#credits)
	- [License](#license)
    
## Quickstart

Simply copy the [Vagrantfile] from this repository to the project you want to
run the VM from and you are done. The box will be downloaded for you.

## Create your own FreeBSD Box

This is for people who want to have their own customized box, instead of the
box I made for you with the scripts in this repository.

The FreeBSD boxse are build from the excellent [mfsBSD] site, namely the
[9.2-RELEASE-amd64 special edition] ISO's. Download this ISO and create a new
virtual machine.

### Virtualbox Settings

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

### Installation from msfBSD ISO

Attach the ISO as a CD and boot it. You can login with `root` and password
`mfsroot`. After logging in, start the base installation with:

    mount_cd9660 /dev/cd0 /cdrom
    zfsinstall -d /dev/ada0 -u /cdrom/9.2-RELEAE-amd64 -s 1G

When the installation is done, you can `poweroff` and **remove the CD from
boot order in the settings.**

### Configuration

Boot into your clean FreeBSD installation. You can now run the
`vagrant-installation.sh` script from this repository. This will install and
setup everything which is needed for Vagrant to run. First, login as root (no
password required).

Select your keyboard:

    kbdmap

Get an IP adress:

    dhclient vtnet0

In your FreeBSD box, fetch the installation script:

    fetch -o /tmp/vagrant-setup.sh https://raw.github.com/wunki/vagrant-freebsd/master/bin/vagrant-setup.sh

Run it:

    cd /tmp
    chmod +x vagrant-setup.sh
    ./vagrant-setup.sh

### Package for Vagrant

Before packaging, I would recommend trying to reduce the size of the disk a
bit more. In Linux you can do:

    VBoxManage modifyvdi <freebsd-virtual-machine>.vdi compact

You can now package the box by running the following on your local machine:

    vagrant package --base <name-of-your-virtual-machine> --output <name-of-your-box>

## What's Next?

You can find the TODO's in the [TODO.org] at the root of this repository.

## Credits

I got lots of useful configuration from [xironix freebsd] builds. 

## License

The above is released under the BSD license -- who would have thought!
Meaning, do whatever you want, but I would sure appreciate if you contribute
any improvements back to this repository.

[FreeBSD]: http://www.freebsd.org/
[Vagrant]: http://www.vagrantup.com/
[jails]: http://www.freebsd.org/doc/handbook/jails.html
[ZFS]: http://en.wikipedia.org/wiki/ZFS
[Vagrantfile]: https://github.com/wunki/vagrant-freebsd/blob/master/Vagrantfile
[mfsBSD]: http://mfsbsd.vx.sk/
[9.2-RELEASE-amd64 special edition]: http://mfsbsd.vx.sk/
[TODO.org]: https://github.com/wunki/vagrant-freebsd/blob/master/TODO.org
[xironix freebsd]: https://github.com/xironix/freebsd-vagrant
