# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'bento/centos-7.2'
  config.vm.synced_folder './', '/vagrant'
  config.vm.provision :shell, path: './provision.sh', keep_color: true
  config.ssh.insert_key = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

end
