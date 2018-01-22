source 'https://rubygems.org'

#
# Configure the build:
#
#   prompt> gem install bundler && bundle install
#

rails_version = ENV.fetch('RAILS_TARGET', '5.1.4').to_s

gemspec

group :test do
  gem 'capybara',                '~> 2.16.1'
  gem 'capybara-screenshot',     '~> 1.0.18'
  gem 'coffee-rails',            '~> 4.2'
  gem 'database_cleaner',        '~> 1.6.2'
  gem 'devise',                  '~> 4.0'
  gem 'flay',                    '~> 2.10.0'
  if Gem::Version.new(rails_version) < Gem::Version.new('5.1.0')
    gem 'jquery-rails'
  end
  gem 'launchy',                 '~> 2.4.3'
  gem 'rails',                   rails_version
  gem 'rspec',                   '~> 3.7'
  gem 'rspec-rails',             '~> 3.7'
  gem 'rspec_junit_formatter',   '~> 0.3'
  gem 'rubocop',                 '>= 0'
  gem 'ruby2ruby',               '~> 2.4.0'
  gem 'sass-rails',              '~> 5.0'
  gem 'selenium-webdriver',      '~> 3.7.0'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'simplecov',               '~> 0.15.1'
  gem 'simplecov-console',       '~> 0.4.2'
  gem 'sqlite3',                 '~> 1.3.13'
  gem 'therubyracer', '~> 0.12.3', platforms: :ruby
end
