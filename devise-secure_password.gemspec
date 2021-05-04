#
#  devise-secure_password.gemspec
#
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require 'devise/secure_password/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise-secure_password'
  spec.version       = Devise::SecurePassword::VERSION.dup
  spec.platform      = Gem::Platform::RUBY

  spec.authors       = ['Mark Eissler']
  spec.email         = ['mark.eissler@valimail.com']

  spec.summary       = 'A devise password policy enforcement extension.'
  spec.description   = 'Adds configurable password policy enforcement to devise.'

  spec.homepage      = 'https://github.com/valimail/devise-secure_password'
  spec.license       = 'MIT'

  spec.files         = Dir['./**/*'].reject do |f|
    f.match(%r{^./(test|spec|features|lib/tasks)/|Gemfile.lock.ci})
  end
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'devise', '>= 4.0.0', '< 5.0.0'
  spec.add_runtime_dependency 'railties', '>= 5.0.0', '< 7.0.0'

  spec.add_development_dependency 'bundler',                 '>= 2.2.14'
  spec.add_development_dependency 'capybara',                '>= 3.35.3'
  spec.add_development_dependency 'capybara-screenshot',     '>= 1.0.18'
  spec.add_development_dependency 'database_cleaner',        '>= 2.0.1'
  spec.add_development_dependency 'devise',                  '~> 4.0'
  spec.add_development_dependency 'flay',                    '>= 2.10.0'
  spec.add_development_dependency 'launchy',                 '>= 2.4.3'
  spec.add_development_dependency 'rails',                   '>= 5.2.0'
  spec.add_development_dependency 'rake',                    '>= 12.3'
  spec.add_development_dependency 'rspec',                   '>= 3.7'
  spec.add_development_dependency 'rspec_junit_formatter',   '>= 0.3'
  spec.add_development_dependency 'rspec-rails',             '>= 3.7'
  spec.add_development_dependency 'rubocop',                 '>= 1.0.0'
  spec.add_development_dependency 'rubocop-rails',           '>= 2.3.2'
  spec.add_development_dependency 'rubocop-rspec',           '>= 1.35.0'
  spec.add_development_dependency 'ruby2ruby',               '>= 2.4.0'
  spec.add_development_dependency 'selenium-webdriver',      '>= 3.7.0'
  spec.add_development_dependency 'simplecov',               '>= 0.18.2'
  spec.add_development_dependency 'simplecov-console',       '>= 0.4.2'
  spec.add_development_dependency 'sqlite3',                 '>= 1.3.13'

  spec.required_ruby_version = '>= 2.7'
end
