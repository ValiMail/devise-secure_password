#
# spec.rake
#
# Run rspec specs.
#
require 'rake'

SPEC_ROOT_DIR = File.expand_path('../../../', __FILE__)

unless Gem::Specification.find_all_by_name('rspec').any?
  abort 'Rspec gem is missing. Install it.'
end
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "#{SPEC_ROOT_DIR}/spec/**/*_spec.rb"
  t.verbose = false
end

# reset default task
desc 'Run RSpec tests'
task default: 'spec'

# move spec task into test namespace for consistency
Rake::Task[:spec].clear_comments
namespace :test do
  desc 'Run RSpec tests (Set COVERAGE=1 to enable SimpleCov)'
  task :spec do
    Rake::Task[:spec].invoke
  end
end
