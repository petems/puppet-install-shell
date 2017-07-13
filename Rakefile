require 'simp/rake/pupmod/helpers'

Simp::Rake::Pupmod::Helpers.new(File.dirname(__FILE__))

def stdout_redirect(command)
  f = IO.popen(command)
  while line = f.gets
    puts line
  end
  f.close
  $?.to_i
end

def only_zero?(array)
  array.count(0) == array.size
end

namespace :acceptance do
  desc "Run all suites for nodeset"
  task :suite_on_nodeset, [:nodeset] do |_t, args|
    exit_code_array = []
    suitenames = Dir.glob('./spec/acceptance/suites/*').select {|f| File.directory? f}
    puts "Suites found: #{suitenames}"
    suitenames.each do | suite |
      suite_command  = "bundle exec rake beaker:suites[#{File.basename(suite)},#{args[:nodeset]}]"
      puts "Running #{suite_command}"
      exit_code = stdout_redirect(suite_command)
      puts "Exit code #{exit_code}"
      exit_code_array << exit_code
    end
    unless only_zero?(exit_code_array)
      puts "Error detected!"
      exit 1
    end
  end
end
