#!/bin/sh

# TODO - Restorte the pkg configuration to default
# TODO - Don't show the boot menu
# TODO - Cleanup pkg's after installation
# TODO - Destroy all history
# TODO - Minimize disk space
# TODO - Edit the MOTD (/etc/motd)

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
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
cat <<EOF > /home/vagrant/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

# rc.conf
cat <<EOF > /etc/rc.conf
# Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
dumpdev="NO"

# Networking
hostname=vagrant-freebsd-92
ifconfig_vtnet0_name="em0"
ifconfig_vtnet1_name="em1"
ifconfig_em0="DHCP"

# ZFS
zfs_enable="YES"

# SSH
sshd_enable="YES"

# Virtualbox
vboxguest_enable="YES"
vboxservice_enable="YES"

# NFS
rpcbind_enable="YES"
nfs_client_enable="YES"

# fsck to protect against unclean shutdowns
fsck_y_enable="YES"

EOF

# loader.conf
cat <<EOF > /boot/loader.conf
zfs_load="YES"
vfs.root.mountfrom="zfs:tank/root"
EOF

# resolv.conf
cat <<EOF > /etc/resolv.conf
search vagrant-freebsd-92
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

