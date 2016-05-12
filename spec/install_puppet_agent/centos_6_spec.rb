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

  context 'install_puppet_agent.sh' do
    describe command('bash -c "./install_puppet_agent.sh"') do
      its(:stdout) { should match /Red hat like platform! Lets get you an RPM.../ }
      its(:stdout) { should match /installing puppetlabs yum repo with rpm.../ }
      its(:stdout) { should match /puppet/ }
      its(:exit_status) { should eq 0 }
    end

    describe command('/opt/puppetlabs/bin/puppet --version') do
      its(:stdout) { should match /^4\./ }
      its(:stderr) { should be_empty }
    end
  end
end
