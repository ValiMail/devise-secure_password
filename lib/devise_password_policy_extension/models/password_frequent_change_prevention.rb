module Devise
  module Models
    module PasswordFrequentChangePrevention
      extend ActiveSupport::Concern

      require 'support/time/comparator'
      require 'support/string/locale_tools'

      Comparator = ::Support::Time::Comparator
      LocaleTools = ::Support::String::LocaleTools

      class ConfigurationError < RuntimeError; end

      included do
        include ActionView::Helpers::DateHelper
        validate :validate_password_frequent_change

        set_callback(:initialize, :before, :before_resource_initialized)
        set_callback(:initialize, :after, :after_resource_initialized)
      end

      def validate_password_frequent_change
        if fresh_password?
          error_string = LocaleTools.replace_macros(
            I18n.translate('dppe.password_frequent_change_prevention.errors.messages.password_is_recent'),
            timeframe: distance_of_time_in_words(self.class.password_minimum_age)
          )
          errors.add(:base, error_string)
        end

        errors.count.zero?
      end

      protected

      def before_resource_initialized
        return if self.class.respond_to?(:password_previously_used_count)

        raise ConfigurationError, <<-ERROR.strip_heredoc

        The password_frequent_change_prevention module depends on the
        password_frequent_reuse_prevention module. Verify that you have
        added both modules to your model, for example:

          devise :database_authenticatable, :registerable,
            :password_frequent_reuse_prevention,
            :password_frequent_change_prevention
        ERROR
      end

      # def after_resource_initialized; end
      def after_resource_initialized
        raise ConfigurationError unless self.class.password_minimum_age.is_a?(::ActiveSupport::Duration)
      end

      def fresh_password?
        last_password = previous_passwords.select(:created_at).last
        unless last_password.nil?
          return !Comparator.time_delay_expired?(last_password.created_at, self.class.password_minimum_age)
        end

        false
      end

      module ClassMethods
        ::Devise::Models.config(self, :password_minimum_age)
      end
    end
  end
end
