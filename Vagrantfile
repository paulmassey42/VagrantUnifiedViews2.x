# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "deimosfr/debian-wheezy"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |vb|
      vb.name = "UnifiedView2.x-wheezy"
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--vram", 64]
      # vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      # Customize the amount of memory on the VM:
      vb.memory = "4096"
  end
  config.vm.provision :shell, path: "bootstrap.sh"
end
