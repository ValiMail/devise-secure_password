ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails-app/config/environment'
require 'rspec/rails'
require 'devise_password_policy_extension'
require 'orm/active_record'
require 'database_cleaner'

# Load all support files including custom matchers and helpers.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# Setup constants for long method paths
require 'support/string/locale_tools'
LocaleTools = ::Support::String::LocaleTools

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

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

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
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

Capybara.register_driver :selenium_chrome_headless do |app|
  chrome_args = %w(headless disable-gpu window-size=1024,768)
  chrome_options = {
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: chrome_args)
  }

  ## additional chrome_options
  ## chrome_options.merge(clear_local_storage: true, clear_session_storage: true)

  Capybara::Selenium::Driver.new(app, chrome_options)
end
Capybara.javascript_driver = :selenium_chrome_headless

#
# Capybara screenshot settings
#
require 'capybara-screenshot/rspec'

Capybara.asset_host = 'http://localhost:3000'
Capybara.save_path = ENV.fetch('CIRCLE_ARTIFACTS', Rails.root.join('tmp', 'capybara')).to_s
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.tr(' ', '-').gsub(%r{^.*\/spec\/}, '')}"
end
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = :keep_last_run
