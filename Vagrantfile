# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'bento/centos-7.2'
  config.vm.synced_folder './', '/vagrant'
  config.vm.provision :shell, path: './provision.sh', keep_color: true
  #config.vm.network 'private_network', type: 'dhcp'
  config.ssh.insert_key = true
end
