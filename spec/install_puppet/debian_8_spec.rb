require "serverspec"
require "docker"

describe "Dockerfile.debian_8" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.',
      {
        'dockerfile' => 'Dockerfile.debian_8'
      }
    )

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end

  context 'install_puppet.sh' do
    describe command('DEBIAN_FRONTEND=noninteractive bash -c "./install_puppet.sh -v 4.5.1"') do
      its(:stdout) { should match /Cannot install Puppet >= 4 with this script, you need to use install_puppet_agent.sh/ }
      its(:stdout) { should_not match /Version parameter defined: 4.5.1/ }
      its(:exit_status) { should eq 1 }
    end

    describe command('DEBIAN_FRONTEND=noninteractive bash -c "./install_puppet.sh"') do
      its(:stdout) { should match /Version parameter not defined, assuming latest/ }
      its(:stdout) { should match /The following NEW packages will be installed:/ }
      its(:stdout) { should match /puppet/ }
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/puppet --version') do
      its(:stdout) { should match /^3\./ }
      its(:stderr) { should be_empty }
    end
  end
end
