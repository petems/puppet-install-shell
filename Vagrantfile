# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #Runs install-puppet.sh on provision. Use 'vagrant up && vagrant destroy' to test all boxes.
  config.vm.provision "shell", path: "install_puppet.sh"
  
  # Want to make sure cachier doesn't give false positives
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = false
  end

  config.vm.define "centos510" do |centos510|
    centos510.vm.box = "chef/centos-5.10"
  end

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

  config.vm.define "squeeze" do |squeeze|
    squeeze.vm.box = "chef/debian-6.0.8"
  end

  config.vm.define "wheezy" do |wheezy|
    wheezy.vm.box = "chef/debian-7.4"
  end

  config.vm.define "fedora19" do |fedora19|
    fedora19.vm.box = "chef/fedora-19"
  end

  config.vm.define "fedora20" do |fedora20|
    fedora20.vm.box = "chef/fedora-20"
  end

  end

  config.vm.define "arch1403" do |arch1404|
    arch1404.vm.box = "cameronmalek/arch1403"
  end

#  Shared folder not available. Tested with:
#   $ curl https://raw.githubusercontent.com/petems/puppet-install-shell/master/install_puppet.sh | sudo sh
#
#  config.vm.define "freebsd10" do |freebsd10|
#    freebsd10.vm.box = "chef/freebsd-10.0"
#  end
#
#  config.vm.define "freebsd9" do |freebsd9|
#    freebsd9.vm.box = "chef/freebsd-9.2"
#  end
end
