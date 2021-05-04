module Devise
  module Models
    module PasswordHasRequiredContent
      extend ActiveSupport::Concern

      require 'support/string/character_counter'

      LENGTH_MAX = 255

      included do
        validate :validate_password_content, if: :password_required?
        validate :validate_password_confirmation_content, if: :password_required?
        validate :validate_password_confirmation, if: :password_required?
      end

      def validate_password_content
        self.password ||= ''
        errors.delete(:password)
        validate_password_content_for(:password)
        errors[:password].count.zero?
      end

      def validate_password_confirmation_content
        return true if password_confirmation.nil? # rails skips password_confirmation validation if nil!

        errors.delete(:password_confirmation)
        validate_password_content_for(:password_confirmation)
        errors[:password_confirmation].count.zero?
      end

      def validate_password_confirmation
        return true if password_confirmation.nil? # rails skips password_confirmation validation if nil!

        unless password == password_confirmation
          human_attribute_name = self.class.human_attribute_name(:password)
          errors.add(:password_confirmation, :confirmation, attribute: human_attribute_name)
        end
        errors[:password_confirmation].count.zero?
      end

      def validate_password_content_for(attr)
        return unless respond_to?(attr) && !(password_obj = send(attr)).nil?

        ::Support::String::CharacterCounter.new.count(password_obj).each do |type, dict|
          error_string =  case type
                          when :length then validate_length(dict[:count])
                          when :unknown then validate_unknown(dict)
                          else validate_type(type, dict)
                          end
          errors.add(attr, error_string) if error_string.present?
        end
      end

      protected

      def validate_unknown(dict)
        type_total = dict.values.reduce(0, :+)
        return if type_total <= required_char_counts_for_type(:unknown)[:max]

        error_string_for_unknown_chars(type_total, dict.keys)
      end

      def validate_type(type, dict)
        type_total = dict.values.reduce(0, :+)
        if type_total < required_char_counts_for_type(type)[:min]
          error_string_for_type_length(type, :min)
        elsif type_total > required_char_counts_for_type(type)[:max]
          error_string_for_type_length(type, :max)
        end
      end

      def validate_length(dict)
        if dict < Devise.password_length.min
          error_string_for_length(:min)
        elsif dict > Devise.password_length.max
          error_string_for_length(:max)
        end
      end

      def error_string_for_length(threshold = :min)
        lang_key = case threshold
                   when :min then 'secure_password.password_has_required_content.errors.messages.minimum_length'
                   when :max then 'secure_password.password_has_required_content.errors.messages.maximum_length'
                   else return ''
                   end

        count = required_char_counts_for_type(:length)[threshold]
        I18n.t(lang_key, count: count, subject: I18n.t('secure_password.character', count: count))
      end

      def error_string_for_type_length(type, threshold = :min)
        lang_key = case threshold
                   when :min then 'secure_password.password_has_required_content.errors.messages.minimum_characters'
                   when :max then 'secure_password.password_has_required_content.errors.messages.maximum_characters'
                   else return ''
                   end

        count = required_char_counts_for_type(type)[threshold]
        error_string = I18n.t(lang_key, count: count, type: I18n.t("secure_password.types.#{type}"), subject: I18n.t('secure_password.character', count: count))
        "#{error_string}  #{dict_for_type(type)}"
      end

      def error_string_for_unknown_chars(count, chars = [])
        I18n.t(
          'secure_password.password_has_required_content.errors.messages.unknown_characters',
          count: count,
          subject: I18n.t('secure_password.character', count: count)
        ) + " (#{chars.join})"
      end

      def dict_for_type(type)
        character_counter = ::Support::String::CharacterCounter.new

        case type
        when :special, :unknown then "(#{character_counter.count_hash[type].keys.join})"
        else
          "(#{character_counter.count_hash[type].keys.first}..#{character_counter.count_hash[type].keys.last})"
        end
      end

      def required_char_counts_for_type(type)
        self.class.config[:REQUIRED_CHAR_COUNTS][type]
      end

      module ClassMethods
        config_params = %i(
          password_required_uppercase_count
          password_required_lowercase_count
          password_required_number_count
          password_required_special_character_count
        )
        ::Devise::Models.config(self, *config_params)

        # rubocop:disable Metrics/MethodLength
        def config
          {
            REQUIRED_CHAR_COUNTS: {
              length: {
                min: Devise.password_length.min,
                max: Devise.password_length.max
              },
              uppercase: {
                min: password_required_uppercase_count,
                max: LENGTH_MAX
              },
              lowercase: {
                min: password_required_lowercase_count,
                max: LENGTH_MAX
              },
              number: {
                min: password_required_number_count,
                max: LENGTH_MAX
              },
              special: {
                min: password_required_special_character_count,
                max: LENGTH_MAX
              },
              unknown: {
                min: 0,
                max: 0
              }
            }
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
