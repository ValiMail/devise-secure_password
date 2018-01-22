#
# rubocop.rake
#
# Run rspec specs.
#
require 'bundler'
require 'rake'

unless Gem::Specification.find_all_by_name('rubocop').any?
  puts 'Rubocop gem is missing. Install it.'
  return
end
require 'rubocop/rake_task'

namespace :test do
  desc 'Run RuboCop code linter tests'
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names']
  end
end
