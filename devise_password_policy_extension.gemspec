#
#  devise_password_policy_extension.gemspec
#
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require 'devise_password_policy_extension/version'

Gem::Specification.new do |spec|
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?(:metadata)
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata['allowed_push_host'] = 'TODO: Set to "http://mygemserver.com"'

  spec.name          = 'devise_password_policy_extension'
  spec.version       = DevisePasswordPolicyExtension::VERSION.dup
  spec.platform      = Gem::Platform::RUBY

  spec.authors       = ['Mark Eissler']
  spec.email         = ['mark.eissler@valimail.com']

  spec.summary       = 'A devise password policy enforcement extension.'
  spec.description   = 'Adds configurable password policy enforcement to devise.'

  spec.homepage      = 'https://github.com/valimail/devise_password_policy_extension'
  spec.license       = 'MIT'

  spec.files         = Dir['./**/*'].reject do |f|
    f.match(%r{^./(test|spec|features)/|Gemfile.lock.ci})
  end
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'devise', '>= 4.0.0', '< 5.0.0'
  spec.add_runtime_dependency 'railties', '>= 4.0.0', '< 6.0.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '> 3.0.0'
  spec.add_development_dependency 'rubocop', '>= 0'
  spec.add_development_dependency 'yard', '>= 0'

  spec.required_ruby_version = '>= 2.4'
end
