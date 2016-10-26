# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "C.UTF-8" # https://oncletom.io/2015/docker-encoding/

Vagrant.configure("2") do |config|
  config.vm.define "server1" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "server1"
    node.vm.network "private_network", ip: "192.168.50.101"
  end
  config.vm.define "server2" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "server2"
    node.vm.network "private_network", ip: "192.168.50.102"
  end
  config.vm.define "server3" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "server3"
    node.vm.network "private_network", ip: "192.168.50.103"
  end

  config.vm.define "myslideshare" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "myslideshare"
    node.vm.network "private_network", ip: "192.168.50.200"
  end

end
