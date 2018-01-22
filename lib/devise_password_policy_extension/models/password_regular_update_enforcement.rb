module Devise
  module Models
    module PasswordRegularUpdateEnforcement
      extend ActiveSupport::Concern

      require 'devise_password_policy_extension/hooks/password_regular_update_enforcement'

      class ConfigurationError < RuntimeError; end

      included do
        set_callback(:initialize, :before, :before_regular_update_initialized)
        set_callback(:initialize, :after, :after_regular_update_initialized)
      end

      def password_expired?
        last_password = previous_passwords.unscoped.last
        inconsistent_password?(last_password) || last_password.stale?(self.class.password_maximum_age)
      end

      protected

      def before_regular_update_initialized
        return if self.class.respond_to?(:password_previously_used_count)

        raise ConfigurationError, <<-ERROR.strip_heredoc

        The password_regular_update_enforcement module depends on the
        password_frequent_reuse_prevention module. Verify that you have
        added both modules to your model, for example:

          devise :database_authenticatable, :registerable,
            :password_frequent_reuse_prevention,
            :password_regular_update_enforcement
        ERROR
      end

      def after_regular_update_initialized
        raise ConfigurationError, 'invalid type for password_maximum_age' \
          unless self.class.password_maximum_age.is_a?(::ActiveSupport::Duration)
      end

      # Check if current password is out of sync with last_password
      #
      # @param last_password [PreviousPassword] Password to compare with current password
      # @return [Boolean] True if password is nil or out of sync, otherwise false
      #
      def inconsistent_password?(last_password = nil)
        last_password.nil? || (encrypted_password != last_password.encrypted_password)
      end

      module ClassMethods
        ::Devise::Models.config(self, :password_maximum_age)
      end
    end
  end
end
