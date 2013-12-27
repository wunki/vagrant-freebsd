#!/bin/sh
################################################################################
# CONFIG
################################################################################

# Packages which are pre-installed
INSTALLED_PACKAGES="virtualbox-ose-additions bash sudo"

# Configuration files
MAKE_CONF="https://raw.github.com/wunki/vagrant-freebsd/master/etc/make.conf"
RC_CONF="https://raw.github.com/wunki/vagrant-freebsd/master/etc/rc.conf"
RESOLV_CONF="https://raw.github.com/wunki/vagrant-freebsd/master/etc/resolv.conf"
LOADER_CONF="https://raw.github.com/wunki/vagrant-freebsd/master/boot/loader.conf"
FBSD_REPOS_CONF="https://raw.github.com/wunki/vagrant-freebsd/master/usr/local/etc/pkg/repos/FreeBSD.conf"

# Message of the day
MOTD="https://raw.github.com/wunki/vagrant-freebsd/master/etc/motd"

# Private key of Vagrant (you probable don't want to change this)
VAGRANT_PRIVATE_KEY="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

################################################################################
# PACKAGE INSTALLATION
################################################################################

# Install the pkg management tool
pkg_add -r pkg

# make.conf
fetch -o /etc/make.conf $MAKE_CONF

# convert pkg
pkg2ng

# Setup pkgng
cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
pkg update
pkg upgrade -y

# Remove PACKAGESITE from config file - deprecated in pkg 1.2
sed -i -e '/PACKAGESITE/d' /usr/local/etc/pkg.conf
# add the FreeBSD package repository
mkdir -p /usr/local/etc/pkg/repos
fetch -o /usr/local/etc/pkg/repos/FreeBSD.conf $FBSD_REPOS_CONF

# Install required packages
for p in $INSTALLED_PACKAGES; do
    pkg install -y "$p"
done

################################################################################
# Configuration
################################################################################

# Create the vagrant user
pw useradd -n vagrant -s /usr/local/bin/bash -m -G wheel -h 0 <<EOP
vagrant
EOP

# Enable sudo for this user
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# Authorize vagrant to login without a key
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh

# Get the public key and save it in the `authorized_keys`
fetch -o /home/vagrant/.ssh/authorized_keys $VAGRANT_PRIVATE_KEY
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# rc.conf
fetch -o /etc/rc.conf $RC_CONF

# resolv.conf
fetch -o /etc/resolv.conf $RESOLV_CONF

# loader.conf
fetch -o /boot/loader.conf $LOADER_CONF

# motd
fetch -o /etc/motd $MOTD


################################################################################
# CLEANUP
################################################################################

# Try to make it even smaller
while true; do
    read -p "Would you like me to zero out all data to reduce box size? [y/N] " yn
    case $yn in
        [Yy]* ) dd if=/dev/zero of=/tmp/ZEROES bs=1M; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Remove the history
cat /dev/null > /root/.history

# Empty out tmp directory
rm -rf /tmp/*

# DONE!
echo "We are all done. Poweroff the box and package it up with Vagrant."
