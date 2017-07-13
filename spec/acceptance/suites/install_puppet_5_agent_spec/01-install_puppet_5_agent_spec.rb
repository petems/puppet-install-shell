require 'spec_helper_acceptance'

describe 'install_puppet_5_agent.sh with no arguments' do

  describe command('bash -c "/var/tmp/puppet-install-shell/install_puppet_5_agent.sh"') do
    if os[:family] == 'redhat'
      its(:stdout) { should match /Red hat like platform! Lets get you an RPM.../ }
      its(:stdout) { should match /installing puppetlabs yum repo with rpm.../ }
    end
    if os[:family] == 'debian'
      its(:stdout) { should match /Debian platform! Lets get you a DEB.../ }
      its(:stdout) { should match /installing puppetlabs apt repo with dpkg.../ }
    end
    its(:stdout) { should match /puppet/ }
    its(:exit_status) { should eq 0 }
  end

  describe command('/opt/puppetlabs/bin/puppet --version') do
    its(:stdout) { should match /^5\./ }
    its(:stderr) { should be_empty }
  end

end
