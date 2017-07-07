require "serverspec"
require "docker"

describe "Dockerfile.ubuntu_1604" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.',
      {
        'dockerfile' => 'Dockerfile.ubuntu_1604'
      }
    )

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end

  context 'install_puppet_5_agent.sh' do
    describe command('DEBIAN_FRONTEND=noninteractive bash -c "./install_puppet_5_agent.sh"') do
      its(:stdout) { should match /Version parameter not defined, assuming latest/ }
      its(:stdout) { should match /The following NEW packages will be installed:/ }
      its(:stdout) { should match /puppet-agent/ }
      its(:exit_status) { should eq 0 }
    end

    describe command('/opt/puppetlabs/bin/puppet --version') do
      its(:stdout) { should match /^5\./ }
      its(:stderr) { should be_empty }
    end
  end
end
