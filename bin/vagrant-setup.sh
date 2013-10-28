#!/bin/sh

################################################################################
# PACKAGE INSTALLATION
################################################################################

# Install the pkg management tool
pkg_add -r pkg

# make.conf
fetch -o /etc/make.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/make.conf

# convert pkg
pkg2ng

# Setup pkgng
cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
sed -i '' -e 's/http:\/\/pkg.freebsd.org\/${ABI}\/latest/http:\/\/pkg.wunki.org\/9_2-amd64-vagrant-default/g' /usr/local/etc/pkg.conf
pkg update
pkg upgrade -y

# Install required packages
packages=(virtualbox-ose-additions bash sudo python)
for p in "${packages[@]}"; do
    pkg install -y $p
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
fetch -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# rc.conf
fetch -o /etc/rc.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/rc.conf

# resolv.conf
fetch -o /etc/resolv.conf https://raw.github.com/wunki/vagrant-freebsd/master/etc/resolv.conf

# loader.conf
fetch -o /boot/loader.conf https://raw.github.com/wunki/vagrant-freebsd/master/boot/loader.conf

# motd
fetch -o /etc/motd https://raw.github.com/wunki/vagrant-freebsd/master/etc/motd

# restore the original pkg.conf
fetch -o /usr/local/etc/pkg.conf https://raw.github.com/wunki/vagrant-freebsd/master/usr/local/etc/pkg.conf

################################################################################
# CLEANUP
################################################################################

# Remove the history
cat /dev/null > /root/.history

# Empty out tmp directory
rm -rf /tmp/*

# Try to make it even smaller
while true; do
    read -p "Would you like me to zero out all data to reduce box size? [y/N] " yn
    case $yn in
        [Yy]* ) dd if=/dev/zero of=/tmp/ZEROES bs=1M; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Empty out tmp directory
rm -rf /tmp/*

# DONE!
echo "We are all done. Poweroff the box and package it up with Vagrant."
