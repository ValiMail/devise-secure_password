ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_TARGET'] ||= '6.1'

#
# Simplecov configuration (COVERAGE=true bundle exec rspec spec/)
#
if ENV['COVERAGE'] && Gem::Specification.find_all_by_name('simplecov').any?
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.start

  if ENV['CI'] == 'true'
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  else
    SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::Console
      ]
    )
    root_dir = File.expand_path('..', __dir__)
    SimpleCov.coverage_dir(File.join(root_dir, 'coverage'))

    SimpleCov.add_filter do |f|
      !f.filename.match? %r{lib/devise/secure_password|lib/support}
    end
    SimpleCov.add_group 'secure_password', 'lib/devise/secure_password'
    SimpleCov.add_group 'support', 'lib/support'
  end
end

rails_dummy = "rails-app-#{ENV['RAILS_TARGET'].tr('.', '_')}"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "#{rails_dummy}/config/environment"
require 'rspec/rails'
require 'devise/secure_password'
require 'orm/active_record'
require 'database_cleaner'

# Load all support files including custom matchers and helpers.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.backtrace_exclusion_patterns << /gems/

  config.include Warden::Test::Helpers

  #
  # Database cleaner (purge test database)
  #
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    DatabaseCleaner.strategy = :truncation unless driver_shares_db_connection_with_specs
  end

  config.before do
    DatabaseCleaner.start
  end

  config.append_after do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

#
# Capybara configuration
#
require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :webrick

Capybara.register_driver :selenium_chrome_headless do |app|
  chrome_args = %w(headless disable-gpu window-size=1024,768)

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: chrome_args))
end
Capybara.javascript_driver = :selenium_chrome_headless

#
# Capybara screenshot settings
#
require 'capybara-screenshot/rspec'

Capybara.asset_host = 'http://localhost:3000'
Capybara.save_path = Rails.root.join('tmp/capybara')
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.tr(' ', '-').gsub(%r{^.*/spec/}, '')}"
end
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = :keep_last_run
