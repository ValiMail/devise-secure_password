#
# lib/devise-secure_password.rb
#
require 'active_support/concern'
require 'devise'
require 'devise/secure_password/routes'
require 'devise/secure_password/version'
require 'devise/secure_password/models/password_has_required_content'
require 'devise/secure_password/models/password_disallows_frequent_reuse'
require 'devise/secure_password/models/password_disallows_frequent_changes'
require 'devise/secure_password/models/password_requires_regular_updates'
require 'devise/secure_password/grammar'

module Devise
  # password_content_enforcement configuration parameters
  @password_required_uppercase_count = 1
  @password_required_lowercase_count = 1
  @password_required_number_count = 1
  @password_required_special_character_count = 1

  # password_frequent_reuse_prevention configuration parameters
  @password_previously_used_count = 8

  # password_frequent_change_prevention configuration parameters
  @password_minimum_age = 1.day

  # password_regular_update_enforcement configuration parameters
  @password_maximum_age = 180.days

  class << self
    attr_accessor :password_required_uppercase_count, :password_required_lowercase_count, :password_required_number_count, :password_required_special_character_count, :password_previously_used_count, :password_minimum_age, :password_maximum_age
  end

  module SecurePassword
    module Controllers
      autoload :Helpers,       'devise/secure_password/controllers/helpers'
      autoload :DeviseHelpers, 'devise/secure_password/controllers/devise_helpers'
    end

    class Engine < ::Rails::Engine
      ActiveSupport.on_load(:devise_controller) do
        include ActionView::Helpers::DateHelper
        include Devise::SecurePassword::Controllers::DeviseHelpers
      end
      ActiveSupport.on_load(:action_controller) do
        include ActionView::Helpers::DateHelper
        include Devise::SecurePassword::Controllers::Helpers
      end

      # add exceptions to the inflector so it doesn't get tripped up by our concerns that end in an 's'
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.uncountable :password_disallows_frequent_changes
        inflect.uncountable :password_requires_regular_updates
      end
    end
  end
end

# modules
Devise.add_module :password_has_required_content, model: 'devise/secure_password/models/password_has_required_content'
Devise.add_module :password_disallows_frequent_reuse, model: 'devise/secure_password/models/password_disallows_frequent_reuse'
Devise.add_module :password_disallows_frequent_changes, model: 'devise/secure_password/models/password_disallows_frequent_changes'
Devise.add_module :password_requires_regular_updates,
                  model: 'devise/secure_password/models/password_requires_regular_updates',
                  controller: :passwords_with_policy, route: :passwords_with_policy
