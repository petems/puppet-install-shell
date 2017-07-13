require 'spec_helper_acceptance'

describe 'install_puppet.sh with no arguments' do

  describe command('bash -c "/var/tmp/puppet-install-shell/install_puppet.sh"') do
    if os[:family] == 'redhat'
      its(:stdout) { should match /Red hat like platform! Lets get you an RPM.../ }
      its(:stdout) { should match /installing puppetlabs yum repo with rpm.../ }
    end
    if os[:family] == 'debian'
      its(:stdout) { should match /Debian platform! Lets get you a DEB.../ }
      if os[:release].to_f > 7
        its(:stdout) { should match /Puppet only offers Puppet 4 packages for Jessie, so only 3.7.2 package avaliable/ }
      else
        its(:stdout) { should match /installing puppetlabs apt repo with dpkg.../ }
      end
    end
    if os[:family] == 'ubuntu'
      its(:stdout) { should match /Ubuntu platform! Lets get you a DEB.../ }
      if os[:release].to_f >= 16
        its(:stdout) { should match /Puppet only offers Puppet 4 packages for Xenial, so only 3.7.2 package avaliable/ }
      else
        its(:stdout) { should match /installing puppetlabs apt repo with dpkg.../ }
      end
    end
    its(:stdout) { should match /puppet/ }
    its(:exit_status) { should eq 0 }
  end

  describe command('/usr/bin/puppet --version') do
    its(:stdout) { should match /^3\./ }
    its(:stderr) { should be_empty }
  end

end
