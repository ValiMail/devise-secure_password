#
# spec.rake
#
# Run rspec specs.
#
require 'rake'

SPEC_ROOT_DIR = File.expand_path('../../spec', __dir__)

unless Gem::Specification.find_all_by_name('rspec').any?
  puts 'Rspec gem is missing. Install it.'
  return
end
require 'rspec/core/rake_task'

def targets
  version_list = Dir.glob("#{SPEC_ROOT_DIR}/rails-app-*").map { |f| File.basename(f).gsub(/^rails-app-/, '').tr('_', '.') if File.directory? f }.sort
  version_list.reverse
end

def default_target
  targets.max { |a, b| a.tr('.', '') <=> b.tr('.', '') }
end

def directory_for_target(target)
  File.join(SPEC_ROOT_DIR, "rails-app-#{target.tr('.', '_')}")
end

def gemfile_for_target(target)
  File.join("gemfiles/rails_#{target.tr('.', '_')}.gemfile")
end

def gemlock_purge_root
  Dir.glob("#{SPEC_ROOT_DIR}/../Gemfile.lock").each { |f| FileUtils.rm(f) }
end

def gemlock_purge_spec
  Dir.glob("#{SPEC_ROOT_DIR}/rails-app-*/Gemfile.lock").each { |f| FileUtils.rm(f) }
end

def available_targets_message
  print <<~MESSAGE

    Available Rails targets: #{targets.join(', ')}

    Reconfigure and test for a specific target:

      prompt> BUNDLE_GEMFILE=#{gemfile_for_target targets.first} bundle exec rake

    The most-recent target is automatically selected as the default and does not
    need to be specified on the command line.

  MESSAGE
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList["#{SPEC_ROOT_DIR}/**/*_spec.rb"].exclude("#{SPEC_ROOT_DIR}/benchmarks/**/**_spec.rb")
  t.verbose = false
end

# reset default task
desc 'Run RSpec tests'
task default: 'spec'

# move spec task into test namespace for consistency
Rake::Task[:spec].clear_comments
namespace :test do
  default_rails = default_target
  desc 'Run RSpec tests (set Rails target with RAILS_TARGET=X.y)'
  task spec: :environment do
    ENV['RAILS_TARGET'] ||= default_rails
    Rake::Task[:spec].invoke
  end
  # add a task for each available rails target version
  namespace :spec do
    desc 'Run RSpec tests with code coverage (SimpleCov)'
    task coverage: :environment do
      ENV['COVERAGE'] = 'true'
      Rake::Task[:spec].invoke
    end
    desc 'List available Rails targets for RSpec tests'
    task targets: :environment do
      available_targets_message
    end
  end
  # purge all gemfile locks
  desc 'Reset the build (when switching Rails targets)'
  task reset: :environment do
    gemlock_purge_root
    gemlock_purge_spec
  end
end
