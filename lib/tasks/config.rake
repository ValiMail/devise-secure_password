#
#  config.rake
#
# Configure the build:
#
#   prompt> gem install bundler
#   prompt> rake config:rails_5_1
#   prompt> bundle install
#
require 'rake'
require 'fileutils'
require 'open3'

ROOT_DIR = File.expand_path('../../../', __FILE__)
GEMFILES = Dir.glob("#{ROOT_DIR}/gemfiles/*.gemfile").map { |e| File.basename(e).gsub(/.gemfile$/, '') if File.file? e }
RAILSAPP_SPEC = 'spec/rails-app'.freeze

def gemfile_extract_semver(filename)
  filename.gsub('rails_', '').tr('_', '.')
end

# Apply patches to application.js (swap rails-ujs for jquery)
# rubocop:disable Metrics/MethodLength
def gemfile_patch_for_version(version)
  target_path = File.join(ROOT_DIR, RAILSAPP_SPEC, 'app', 'assets', 'javascripts', 'application.js')

  terms = if gemfile_name_compare(version, '5.1.0').negative?
            [
              's#// require jquery$#//= require jquery#',
              's#// require jquery_ujs#//= require jquery_ujs#',
              's#//= require rails-ujs#// require rails-ujs#'
            ]
          else
            [
              's#//= require jquery$#// require jquery#',
              's#//= require jquery_ujs#// require jquery_ujs#',
              's#// require rails-ujs#//= require rails-ujs#'
            ]
          end

  command = "sed -i.bak '#{terms.join(';')}' #{target_path}"
  rslt, _status = Open3.capture2(command)
  rslt
end
# rubocop:enable Metrics/MethodLength

def gemfile_name_to_version(filename)
  filename.gsub('rails_', '').tr('_', '.')
end

def gemfile_copy_to_root(filename)
  printf "Copying: #{filename} to Gemfile\n"
  source_path = File.join(ROOT_DIR, 'gemfiles', filename)
  target_path = File.join(ROOT_DIR, 'Gemfile')
  FileUtils.cp(source_path, target_path)
end

def gemfile_copy_to_spec(filename)
  printf "Copying: #{filename} to #{RAILSAPP_SPEC}/Gemfile\n"
  source_path = File.join(ROOT_DIR, RAILSAPP_SPEC, 'gemfiles', filename)
  target_path = File.join(ROOT_DIR, RAILSAPP_SPEC, 'Gemfile')
  FileUtils.cp(source_path, target_path)
end

def gemfile_name_compare(filename_a, filename_b)
  Gem::Version.new(gemfile_extract_semver(filename_a)) <=> Gem::Version.new(gemfile_extract_semver(filename_b))
end

def gemfile_update(filename)
  gemfile_copy_to_root(filename)
  gemfile_copy_to_spec(filename)
end

def gemlock_purge_root
  target_path = File.join(ROOT_DIR, 'Gemfile.lock')
  FileUtils.rm(target_path) if File.exist?(target_path)
end

def gemlock_purge_spec
  target_path = File.join(ROOT_DIR, RAILSAPP_SPEC, 'Gemfile.lock')
  FileUtils.rm(target_path) if File.exist?(target_path)
end

if Gem::Specification.find_all_by_name('rails').any?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.verbose = false
  end
end

desc 'Run tests'
task default: :spec

namespace :config do
  GEMFILES.each do |version|
    desc "Reconfigure Gemfiles for Rails #{gemfile_name_to_version version}" unless version == 'rails_0_0'
    task version => %w(config:reset) do |t, _args|
      confname = t.name.split(':')[1]
      confvers = gemfile_name_to_version(confname)
      message = (version == 'rails_0_0' ? 'Resetting build' : "Reconfiguring build for: Rails #{confvers}")
      printf "%s\n", message
      filename = confname + '.gemfile'
      # update gemfiles
      gemfile_update(filename)
      # apply patches
      gemfile_patch_for_version(confvers)
      message = (version == 'rails_0_0' ? 'Build has been reset' : "Build has been reconfigured for Rails #{confvers}")
      printf "%s\n", message
    end
  end

  desc 'Reconfigure Gemfiles for default Rails target'
  task :default do
    default_config = GEMFILES.max { |a, b| gemfile_name_compare(a, b) }
    Rake::Task["config:#{default_config}"].invoke
  end

  desc 'Reset the build (inbetween configuration changes)'
  task :reset do
    Rake::Task['config:rails_0_0'].invoke
    gemlock_purge_root
    gemlock_purge_spec
  end
end
