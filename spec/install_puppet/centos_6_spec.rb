require "serverspec"
require "docker"

describe "Dockerfile.centos_6" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.',
      {
        'dockerfile' => 'Dockerfile.centos_6'
      }
    )

    set :os, family: :redhat
    set :backend, :docker
    set :docker_image, @image.id
  end

  context 'install_puppet.sh' do
    describe command('bash -c "./install_puppet.sh -v 4.5.1"') do
      its(:stdout) { should match /Cannot install Puppet >= 4 with this script, you need to use install_puppet_agent.sh/ }
      its(:stdout) { should_not match /Version parameter defined: 4.5.1/ }
      its(:exit_status) { should eq 1 }
    end

    describe command('bash -c "./install_puppet.sh"') do
      its(:stdout) { should match /Red hat like platform! Lets get you an RPM.../ }
      its(:stdout) { should match /installing puppetlabs yum repo with rpm.../ }
      its(:stdout) { should match /puppet/ }
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/puppet --version') do
      its(:stdout) { should match /^3\./ }
      its(:stderr) { should be_empty }
    end
  end
end
