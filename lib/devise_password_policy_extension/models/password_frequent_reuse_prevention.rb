module Devise
  module Models
    module PasswordFrequentReusePrevention
      extend ActiveSupport::Concern

      require 'devise_password_policy_extension/models/previous_password'
      require 'support/string/locale_tools'

      LocaleTools = ::Support::String::LocaleTools

      included do
        # we need to specify the foreign_key here to support the use of subclasses in tests
        has_many :previous_passwords, class_name: 'Devise::Models::PreviousPassword', foreign_key: 'user_id', dependent: :destroy
        validate :validate_password_frequent_reuse

        set_callback(:save, :before, :before_resource_saved)
        set_callback(:save, :after, :after_resource_saved, if: :dirty_password?)
      end

      def validate_password_frequent_reuse
        if previous_password?(password)
          error_string = LocaleTools.replace_macros(
            I18n.translate('dppe.password_frequent_reuse_prevention.errors.messages.password_is_recent'),
            count: self.class.password_previously_used_count
          )
          errors.add(:base, error_string)
        end

        errors.count.zero?
      end

      protected

      def before_resource_saved; end

      def after_resource_saved
        salt = ::BCrypt::Password.new(encrypted_password).salt
        previous_password = previous_passwords.build(user_id: id, salt: salt, encrypted_password: encrypted_password)
        previous_password.save!
        purge_previous_passwords(self, self.class.password_previously_used_count)
      end

      def previous_password?(password)
        salts = previous_passwords.select(:salt).map(&:salt)
        pepper = self.class.pepper.presence || ''

        salts.each do |salt|
          candidate = ::BCrypt::Engine.hash_secret("#{password}#{pepper}", salt)
          return true unless previous_passwords.find_by(encrypted_password: candidate).nil?
        end

        false
      end

      def purge_previous_passwords(user, count)
        return unless (diff = user.previous_passwords.count - (count + 1)).positive?
        user.previous_passwords.last(diff).map(&:destroy!)
      end

      def dirty_password?
        if Rails.version > '5.1'
          saved_change_to_encrypted_password?
        else
          encrypted_password_changed?
        end
      end

      module ClassMethods
        config_params = %i(
          password_previously_used_count
        )
        ::Devise::Models.config(self, *config_params)
      end
    end
  end
end
