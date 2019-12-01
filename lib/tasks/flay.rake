#
# flay.rake
#
# Run flay code coverage tasks.
#
require 'rake'

FLAY_ROOT_DIR = File.expand_path('../..', __dir__)
FLAY_FILES = Dir.glob("#{FLAY_ROOT_DIR}/lib/devise/secure_password/**/*.rb")

unless Gem::Specification.find_all_by_name('flay').any?
  puts 'Flay gem is missing. Install it.'
  return
end
require 'flay'
require 'flay_task'

unless Gem::Specification.find_all_by_name('ruby2ruby').any?
  puts 'Flay code coverage tests require ruby2ruby gem. Install it.'
  return
end
require 'ruby2ruby'

# rubocop:disable Rails/RakeEnvironment
namespace :test do
  desc 'Run Flay code coverage tests'
  task :flay do
    flay = Flay.new(Flay.default_options.merge(diff: true, mass: 35))
    flay.process(*FLAY_FILES)
    flay.report
  end
end
# rubocop:enable Rails/RakeEnvironment
