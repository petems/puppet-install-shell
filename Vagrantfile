# -*- mode: ruby -*-
# vi: set ft=ruby :

if Vagrant::VERSION < '1.5.0'
  fail 'This Vagrantfile uses Vagrantcloud, upgrade to > 1.5.0!'
end

Vagrant.configure("2") do |config|

   # Want to make sure cachier doesn't give false positives
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = false
  end

  config.vm.define "sles_12_puppet_agent" do |sles_12_puppet_agent|
    sles_12_puppet_agent.vm.box = "elastic/sles-12-x86_64"
    sles_12_puppet_agent.vm.provision "shell", inline: "zypper -n rm puppet-agent"
    sles_12_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh", args: "-v 4.6.2"
    sles_12_puppet_agent.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet --version"
  end

  config.vm.define "sles_11_puppet_agent" do |sles_11_puppet_agent|
    sles_11_puppet_agent.vm.box = "elastic/sles-11-x86_64"
    sles_11_puppet_agent.vm.provision "shell", inline: "zypper -n rm puppet-agent"
    sles_11_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh", args: "-v 4.6.2"
    sles_11_puppet_agent.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet --version"
  end

  config.vm.define "vivid_puppet_agent" do |vivid_puppet_agent|
    vivid_puppet_agent.vm.box = "ubuntu/vivid64"
    vivid_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh", args: "-v 4.3.1"
    vivid_puppet_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "trusty_puppet_agent" do |trusty_puppet_agent|
    trusty_puppet_agent.vm.box = "ubuntu/trusty64"
    trusty_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh", args: "-v 4.3.1"
    trusty_puppet_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "xenial_puppet_agent" do |xenial_puppet_agent|
    xenial_puppet_agent.vm.box = "ubuntu/xenial64"
    xenial_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh"
    xenial_puppet_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora23_puppet_agent" do |fedora23_puppet_agent|
    fedora23_puppet_agent.vm.box = "fedora/23-cloud-base"
    fedora23_puppet_agent.vm.provision "shell", path: "install_puppet_agent.sh", args: "-v 4.3.1"
    fedora23_puppet_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "jessie_puppet_5_agent" do |jessie_puppet_5_agent|
    jessie_puppet_5_agent.vm.box = "debian/jessie64"
    jessie_puppet_5_agent.vm.provision "shell", path: "install_puppet_5_agent.sh"
    jessie_puppet_5_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "xenial_puppet_5_agent" do |xenial_puppet_5_agent|
    xenial_puppet_5_agent.vm.box = "ubuntu/xenial64"
    xenial_puppet_5_agent.vm.provision "shell", path: "install_puppet_5_agent.sh"
    xenial_puppet_5_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "centos7_puppet_5_agent" do |centos7_puppet_5_agent|
    centos7_puppet_5_agent.vm.box = "centos/7"
    centos7_puppet_5_agent.vm.provision "shell", path: "install_puppet_5_agent.sh"
    centos7_puppet_5_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora25_puppet_5_agent" do |fedora25_puppet_5_agent|
    fedora25_puppet_5_agent.vm.box = "fedora/25-cloud-base"
    fedora25_puppet_5_agent.vm.provision "shell", path: "install_puppet_5_agent.sh"
    fedora25_puppet_5_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "jessie_puppet_6_agent" do |jessie_puppet_6_agent|
    jessie_puppet_6_agent.vm.box = "debian/jessie64"
    jessie_puppet_6_agent.vm.provision "shell", path: "install_puppet_6_agent.sh"
    jessie_puppet_6_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "xenial_puppet_6_agent" do |xenial_puppet_6_agent|
    xenial_puppet_6_agent.vm.box = "ubuntu/xenial64"
    xenial_puppet_6_agent.vm.provision "shell", path: "install_puppet_6_agent.sh"
    xenial_puppet_6_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "centos7_puppet_6_agent" do |centos7_puppet_6_agent|
    centos7_puppet_6_agent.vm.box = "centos/7"
    centos7_puppet_6_agent.vm.provision "shell", path: "install_puppet_6_agent.sh"
    centos7_puppet_6_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora25_puppet_6_agent" do |fedora25_puppet_6_agent|
    fedora25_puppet_6_agent.vm.box = "fedora/25-cloud-base"
    fedora25_puppet_6_agent.vm.provision "shell", path: "install_puppet_6_agent.sh"
    fedora25_puppet_6_agent.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "jessie_non_agent" do |jessie|
    jessie.vm.box = "debian/jessie64"
    jessie.vm.provision "shell", path: "install_puppet.sh", args: "-v 3.7.2-4"
    jessie.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "wheezy" do |wheezy|
    wheezy.vm.box = "debian/wheezy64"
    wheezy.vm.provision "shell", path: "install_puppet.sh", args: "-v 3.7.2"
    wheezy.vm.provision "shell", inline: "puppet --version"
  end

  # Test for facter issue from https://github.com/petems/vagrant-puppet-install/issues/6
  config.vm.define "GH6" do |gh6|
    gh6.vm.box = "bento/ubuntu-12.04-i386"
    gh6.vm.provision "shell", path: "install_puppet.sh", args: "-v 2.7.23"
    gh6.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "GH6_centos" do |gh6_centos|
    gh6_centos.vm.box = "puppetlabs/centos-6.6-64-nocm"
    gh6_centos.vm.provision "shell", path: "install_puppet.sh", args: "-v 2.7.23"
    gh6_centos.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "xenial_puppet" do |xenial_puppet|
    xenial_puppet.vm.box = "ubuntu/xenial64"
    xenial_puppet.vm.provision "shell", path: "install_puppet.sh"
    xenial_puppet.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "centos67" do |centos67|
    centos67.vm.box = "puppetlabs/centos-6.6-64-nocm"
    centos67.vm.provision "shell", path: "install_puppet.sh"
    centos67.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "puppetlabs/centos-7.2-64-nocm"
    centos7.vm.provision "shell", path: "install_puppet.sh"
    centos7.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "precise64" do |precise64|
    precise64.vm.box = "bento/ubuntu-12.04"
    precise64.vm.provision "shell", path: "install_puppet.sh"
    precise64.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "quantal64" do |quantal64|
    quantal64.vm.box = "bento/ubuntu-12.10"
    quantal64.vm.provision "shell", path: "install_puppet.sh"
    quantal64.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "raring64" do |raring64|
    raring64.vm.box = "bento/ubuntu-13.04"
    raring64.vm.provision "shell", path: "install_puppet.sh"
    raring64.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "saucy64" do |saucy64|
    saucy64.vm.box = "bento/ubuntu-13.10"
    saucy64.vm.provision "shell", path: "install_puppet.sh"
    saucy64.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "trusty64" do |trusty64|
    trusty64.vm.box = "bento/ubuntu-14.04"
    trusty64.vm.provision "shell", path: "install_puppet.sh"
    trusty64.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "squeeze" do |squeeze|
    squeeze.vm.box = "bento/debian-6.0.8"
    squeeze.vm.provision "shell", path: "install_puppet.sh"
    squeeze.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "jessie" do |jessie|
    jessie.vm.box = "bento/debian-8.2"
    jessie.vm.provision "shell", path: "install_puppet_agent.sh"
    jessie.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora19" do |fedora19|
    fedora19.vm.box = "bento/fedora-19"
    fedora19.vm.provision "shell", path: "install_puppet.sh"
    fedora19.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora20" do |fedora20|
    fedora20.vm.box = "bento/fedora-20"
    fedora20.vm.provision "shell", path: "install_puppet.sh"
    fedora20.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "fedora21" do |fedora20|
    fedora20.vm.box = "bento/fedora-21"
    fedora20.vm.provision "shell", path: "install_puppet.sh"
    fedora20.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "arch" do |arch|
    arch.vm.box = "losingkeys/arch"
    arch.vm.provision "shell", path: "install_puppet.sh"
    arch.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "freebsd9" do |freebsd9|
    freebsd9.ssh.shell = 'sh'
    freebsd9.vm.guest = :freebsd
    freebsd9.vm.box = "bento/freebsd-9.2"
    freebsd9.vm.provision "shell", path: "install_puppet.sh"
    freebsd9.vm.provision "shell", inline: "puppet --version"
  end

  config.vm.define "freebsd10" do |freebsd10|
    freebsd10.ssh.shell = 'sh'
    freebsd10.vm.guest = :freebsd
    freebsd10.vm.box = "bento/freebsd-10.0"
    freebsd10.vm.provision "shell", path: "install_puppet.sh"
    freebsd10.vm.provision "shell", inline: "puppet --version"
  end

end
