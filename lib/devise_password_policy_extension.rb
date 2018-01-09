#
# lib/devise_password_policy_extension.rb
#
require 'active_support/concern'
require 'devise'
require 'devise_password_policy_extension/routes'
require 'devise_password_policy_extension/version'
require 'devise_password_policy_extension/models/password_content_enforcement'
require 'devise_password_policy_extension/models/password_frequent_reuse_prevention'
require 'devise_password_policy_extension/models/password_frequent_change_prevention'
require 'devise_password_policy_extension/models/password_regular_update_enforcement'

module Devise
  # password_content_enforcement configuration parameters
  @password_required_uppercase_count = 1
  @password_required_lowercase_count = 1
  @password_required_number_count = 1
  @password_required_special_count = 1

  # password_frequent_reuse_prevention configuration parameters
  @password_previously_used_count = 24

  # password_frequent_change_prevention configuration parameters
  @password_minimum_age = 1.day

  # password_regular_update_enforcement configuration parameters
  @password_maximum_age = 60.days

  class << self
    attr_accessor :password_required_uppercase_count
    attr_accessor :password_required_lowercase_count
    attr_accessor :password_required_number_count
    attr_accessor :password_required_special_count
    attr_accessor :password_previously_used_count
    attr_accessor :password_minimum_age
    attr_accessor :password_maximum_age
  end
end

module DevisePasswordPolicyExtension
  module Controllers
    autoload :DeviseHelpers, 'devise_password_policy_extension/controllers/devise_helpers'
    autoload :ActiveHelpers, 'devise_password_policy_extension/controllers/active_helpers'
  end

  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:devise_controller) do
      include ActionView::Helpers::DateHelper
      include DevisePasswordPolicyExtension::Controllers::DeviseHelpers
    end
    ActiveSupport.on_load(:action_controller) do
      include ActionView::Helpers::DateHelper
      include DevisePasswordPolicyExtension::Controllers::ActiveHelpers
    end
  end
end

# modules
Devise.add_module :password_content_enforcement, model: 'devise_password_policy_extension/models/password_content_enforcement'
Devise.add_module :password_frequent_reuse_prevention, model: 'devise_password_policy_extension/models/password_frequent_reuse_prevention'
Devise.add_module :password_frequent_change_prevention, model: 'devise_password_policy_extension/models/password_frequent_change_prevention'
Devise.add_module :password_regular_update_enforcement,
                  model: 'devise_password_policy_extension/models/password_regular_update_enforcement',
                  controller: :password_regular_update_enforcement, route: :password_regular_update_enforcement
