# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder ".", "/vagrant"
  config.vm.define "swarm-master" do |d|
    d.vm.box = "ubuntu/trusty64"
    d.vm.hostname = "swarm-master"
    d.vm.network "private_network", ip: "10.100.195.200"
    d.vm.provider "virtualbox" do |v|
      v.memory = 1536
      v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    d.vm.provision :shell, path: "scripts/bootstrap_ansible.sh"
  end
  (1..3).each do |i|
    config.vm.define "swarm-node-#{i}" do |d|
      d.vm.box = "ubuntu/trusty64"
      d.vm.hostname = "swarm-node-#{i}"
      d.vm.network "private_network", ip: "10.100.195.20#{i}"
      d.vm.provider "virtualbox" do |v|
        v.memory = 1536
        v.customize ["modifyvm", :id, "--nictype1", "virtio"]
      end
    end
  end
end