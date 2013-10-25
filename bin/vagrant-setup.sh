#!/bin/sh

# Install the pkg management tool
pkg_add -r pkg

# Setup pkgng
cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
sed -i '' -e 's/http:\/\/pkg.freebsd.org\/${ABI}\/latest/http:\/\/pkg.wunki.org\/9_2-amd64-vagrant-default/g' /usr/local/etc/pkg.conf
pkg update
pkg upgrade -y

# Default package site is: http://pkg.freebsd.org/${ABI}/latest

# Install required packages
pkg install -y virtualbox-ose-additions
pkg install -y bash
pkg install -y sudo

# Create the vagrant user
pw useradd -n vagrant -s /usr/local/bin/bash -m -G wheel -h 0 <<EOP
vagrant
EOP

# Enable sudo for this user
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# TODO: Set `UseDNS` to no for SSH

# Authorize vagrant to login without a key
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh

# Get the public key and save it in the `authorized_keys`
fetch -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# rc.conf
fetch -o /etc/rc.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/rc.conf

# resolv.conf
fetch -o /etc/resolv.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/resolv.conf

# loader.conf
fetch -o /etc/loader.conf https://raw.github.com/wunki/vagrant-freebsd/master/boot/loader.conf

# make.conf
fetch -o /etc/make.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/make.conf

# motd
fetch -o /etc/motd https://raw.github.com/wunki/vagrant-freebsd/master/etc/motd
