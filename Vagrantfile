# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'bento/centos-7.2'
  config.vm.synced_folder './', '/vagrant', type: 'virtualbox'
  config.vm.provision :shell, path: './bin/provision.sh', keep_color: true
  config.ssh.insert_key = true
end
