source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'pry'
  gem 'rb-readline'
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem 'beaker-puppet_install_helper',  :require => false
  gem 'simp-beaker-helpers', :git => 'https://github.com/petems/rubygem-simp-beaker-helpers', :branch => 'testing_non_puppet'
  gem 'simp-rake-helpers'
end

# vim: syntax=ruby
