require 'simp/beaker_helpers'
include Simp::BeakerHelpers
require 'beaker-rspec'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      scp_to(host, proj_root, '/var/tmp/')
    end
  end
end
