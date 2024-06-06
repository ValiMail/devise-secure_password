module Devise
  module Models
    module PasswordDisallowsFrequentChanges
      extend ActiveSupport::Concern

      class ConfigurationError < RuntimeError; end

      included do
        include ActionView::Helpers::DateHelper
        include Devise::SecurePassword::Grammar

        validate :validate_password_frequent_change, if: :password_required?

        set_callback(:initialize, :before, :before_resource_initialized)
        set_callback(:initialize, :after, :after_resource_initialized)
      end

      def validate_password_frequent_change
        if encrypted_password_changed? && password_recent?
          error_string = I18n.t(
            'secure_password.password_disallows_frequent_changes.errors.messages.password_is_recent',
            timeframe: precise_distance_of_time_in_words(self.class.password_minimum_age)
          )
          errors.add(:base, error_string)
        end

        errors.count.zero?
      end

      def password_recent?
        last_password = previous_passwords.first
        last_password&.fresh?(self.class.password_minimum_age)
      end

      protected

      def before_resource_initialized
        return if self.class.respond_to?(:password_previously_used_count)

        raise ConfigurationError, <<~ERROR

          The password_disallows_frequent_changes module depends on the
          password_disallows_frequent_reuse module. Verify that you have
          added both modules to your model, for example:

            devise :database_authenticatable, :registerable,
              :password_disallows_frequent_reuse,
              :password_disallows_frequent_changes
        ERROR
      end

      def after_resource_initialized
        raise ConfigurationError, 'invalid type for password_minimum_age' \
          unless self.class.password_minimum_age.is_a?(::ActiveSupport::Duration)
      end

      module ClassMethods
        ::Devise::Models.config(self, :password_minimum_age)
      end
    end
  end
end
