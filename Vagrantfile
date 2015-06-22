# -*- mode: ruby; -*-

# Force Virtualbox for those people who have installed vagrant-lxc (e.g.)
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
  config.vm.guest = :freebsd
  config.vm.network "private_network", ip: "10.0.1.10"

  # Use NFS as a shared folder
  config.vm.synced_folder ".", "/vagrant", :nfs => true, id: "vagrant-root"

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box_url = "http://files.wunki.org/freebsd-10.1-amd64-wunki.box"
    override.vm.box = "freebsd-10.1-amd64-wunki"

    # vb.customize ["startvm", :id, "--type", "gui"]
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end
end
