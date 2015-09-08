# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  # boot2docker VM
  config.vm.box = "c6"
  # Install stuff inside VM by running bootstrap.sh
  config.vm.provision :shell, path: "bootstrap.sh"

  # Set an IP
  config.vm.network "private_network", ip: "192.168.33.10"
  # mount image folder into VM
  config.vm.synced_folder "./images", "/vagrant"

  # Set memory and CPU 
  config.vm.provider "virtualbox" do |v|
      v.name = "C6"
      v.memory = 2048
      v.cpus = 8
  end

end
