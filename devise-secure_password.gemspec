#
#  devise-secure_password.gemspec
#
lib = File.expand_path('../lib', __FILE__)
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
  spec.add_runtime_dependency 'railties', '>= 5.0.0', '< 6.0.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'yard', '>= 0'

  spec.required_ruby_version = '>= 2.4'
end
