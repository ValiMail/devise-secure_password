require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "devise"
require "devise/rails"
require "devise_password_policy_extension"

module RailsApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    if Rails.version >= '5.1'
      config.load_defaults 5.1
    else
      config.active_record.belongs_to_required_by_default = true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
