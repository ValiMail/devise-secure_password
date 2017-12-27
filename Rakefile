require 'bundler'

# verify dependency installation
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.printf "%s\n", e.message
  $stderr.printf "To install missing gems...\n\n"
  $stderr.printf "\tprompt> bundle install\n"
  exit e.status_code
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

task default: :spec

require 'yard'
YARD::Rake::YardocTask.new
