#
# lib/devise_password_policy_extension.rb
#
require 'active_support/concern'
require 'devise'
require 'devise_password_policy_extension/version'
require 'devise_password_policy_extension/models/password_content_enforcement'
require 'devise_password_policy_extension/models/password_frequent_reuse_prevention'
require 'devise_password_policy_extension/models/password_frequent_change_prevention'

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

  class << self
    attr_accessor :password_required_uppercase_count
    attr_accessor :password_required_lowercase_count
    attr_accessor :password_required_number_count
    attr_accessor :password_required_special_count
    attr_accessor :password_previously_used_count
    attr_accessor :password_minimum_age
  end
end

module DevisePasswordPolicyExtension
end

# modules
Devise.add_module :password_content_enforcement, model: 'devise_password_policy_extension/models/password_content_enforcement'
Devise.add_module :password_frequent_reuse_prevention, model: 'devise_password_policy_extension/models/password_frequent_reuse_prevention'
Devise.add_module :password_frequent_change_prevention, model: 'devise_password_policy_extension/models/password_frequent_change_prevention'
