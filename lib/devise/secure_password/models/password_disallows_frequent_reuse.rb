module Devise
  module Models
    module PasswordDisallowsFrequentReuse
      extend ActiveSupport::Concern

      require 'devise/secure_password/models/previous_password'

      included do
        # we need to specify the foreign_key here to support the use of isolated subclasses in tests
        has_many :previous_passwords,
                 -> { limit(User.password_previously_used_count) },
                 class_name: 'Devise::Models::PreviousPassword',
                 foreign_key: 'user_id',
                 dependent: :destroy
        validate :validate_password_frequent_reuse, if: :password_required?

        set_callback(:save, :before, :before_resource_saved)
        set_callback(:save, :after, :after_resource_saved, if: :dirty_password?)
      end

      def validate_password_frequent_reuse
        if encrypted_password_changed? && previous_password?(password)
          error_string = I18n.t(
            'secure_password.password_disallows_frequent_reuse.errors.messages.password_is_recent',
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
      end

      def previous_password?(password)
        salts = previous_passwords.pluck(:salt)
        pepper = self.class.pepper.presence || ''

        salts.each do |salt|
          candidate = ::BCrypt::Engine.hash_secret("#{password}#{pepper}", salt)
          return true unless previous_passwords.find_by(encrypted_password: candidate).nil?
        end

        false
      end

      def dirty_password?
        return false unless password_required?

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
