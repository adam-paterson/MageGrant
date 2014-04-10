# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/var/www"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  
  # Before provisioning the vm using puppet install librarian-puppet for easy package management
  config.vm.provision "shell" do |s|
    s.path = "puppet/shell/initial-setup.sh"
  end
  
  config.vm.provision :shell, :path => "puppet/shell/puppet-setup.sh"
  
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
  end
end
