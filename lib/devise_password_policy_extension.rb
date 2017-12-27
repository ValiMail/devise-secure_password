#
# lib/devise_password_policy_extension.rb
#
require 'active_support/concern'
require 'devise'
require 'devise_password_policy_extension/version'
require 'devise_password_policy_extension/models/password_content_enforcement'

module Devise
  @password_required_uppercase_count = 1
  @password_required_lowercase_count = 1
  @password_required_number_count = 1
  @password_required_special_count = 1

  class << self
    attr_accessor :password_required_uppercase_count
    attr_accessor :password_required_lowercase_count
    attr_accessor :password_required_number_count
    attr_accessor :password_required_special_count
  end
end

module DevisePasswordPolicyExtension
  # Your code goes here...
end

# modules
Devise.add_module :password_content_enforcement, model: 'devise_password_policy_extension/models/password_content_enforcement'
