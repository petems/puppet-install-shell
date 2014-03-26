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

  if Vagrant::VERSION < "1.5.0"
    config.vm.define "centos65" do |centos65|
      centos65.vm.box = "centos6.5"
      centos65.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"
    end

    config.vm.define "precise64" do |precise64|
      precise64.vm.box = "precise64"
      precise64.vm.box_url = "http://files.vagrantup.com/precise64.box"
    end

    config.vm.define "quantal64" do |quantal64|
      quantal64.vm.box = "quantal64"
      quantal64.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/quantal/current/quantal-server-cloudimg-amd64-vagrant-disk1.box"
    end
  else
    config.vm.define "centos65" do |centos65|
      centos65.vm.box = "chef/centos-6.5"
    end

    config.vm.define "precise64" do |precise64|
      precise64.vm.box = "chef/ubuntu-12.04"
    end

    config.vm.define "quantal64" do |quantal64|
      quantal64.vm.box = "chef/ubuntu-12.10"
    end

    config.vm.define "raring64" do |raring64|
      raring64.vm.box = "chef/ubuntu-13.04"
    end

    config.vm.define "saucy64" do |saucy64|
      saucy64.vm.box = "chef/ubuntu-13.10"
    end

    config.vm.define "centos510" do |centos510|
      centos510.vm.box = "chef/centos-5.10"
    end

    config.vm.define "wheezy" do |wheezy|
      wheezy.vm.box = "chef/debian-7.4"
    end

    config.vm.define "squeeze" do |squeeze|
      squeeze.vm.box = "chef/debian-6.0.8"
    end

    config.vm.define "fedora20" do |fedora20|
      fedora20.vm.box = "chef/fedora-20"
    end

  end




end
