# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Want to make sure cachier doesn't give false positives
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = false
  end

  config.vm.provider "virtualbox" do |v|
    # v.gui = true
  end

  config.vm.define "centos65" do |centos65|
    centos65.vm.box = "centos6.5"
    centos65.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"
  end

  config.vm.define "precise64" do |precise64|
    precise64.vm.box = "precise64"
    precise64.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  config.vm.define "arch64" do |arch64|
    arch64.vm.box = "arch64"
    arch64.vm.box_url = 'https://www.dropbox.com/s/c2nbeei1wi36ao6/packer_virtualbox-iso_virtualbox.box'
    # Generated from https://github.com/daimatz/arch64-packer
  end

end
