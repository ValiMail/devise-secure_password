#
# benchmarks.rake
#
# Run benchmarks.
#
require 'rake'

BENCHMARK_ROOT_DIR = File.expand_path('../../spec/benchmarks', __dir__)

unless Gem::Specification.find_all_by_name('rspec').any?
  puts 'Rspec gem is missing. Install it.'
  return
end
require 'rspec/core/rake_task'

namespace :test do
  desc 'Run benchmark tests'
  RSpec::Core::RakeTask.new(:benchmark) do |t|
    t.pattern = "#{BENCHMARK_ROOT_DIR}/**/*.rb"
    t.verbose = false
  end

  namespace :benchmark do
    desc 'Run benchmark tests for single file'
    RSpec::Core::RakeTask.new(:file, [:path]) do |t, args|
      printf "Benchmarking a single file: #{args.path}...\n"
      t.pattern = args.path
      t.verbose = false
    end
  end
end
