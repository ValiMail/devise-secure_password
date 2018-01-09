module Devise
  module Models
    module PasswordContentEnforcement
      extend ActiveSupport::Concern

      require 'support/string/character_counter'
      require 'support/string/locale_tools'
      require 'support/math/integer'

      LocaleTools = ::Support::String::LocaleTools

      included do
        validate :validate_password_content
        validate :validate_password_confirmation_content
      end

      def validate_password_content
        self.password ||= ''
        validate_password_content_for(:password)
        errors[:password].count.zero?
      end

      def validate_password_confirmation_content
        self.password_confirmation ||= ''
        validate_password_content_for(:password_confirmation)
        errors[:password_confirmation].count.zero?
      end

      def validate_password_content_for(attr)
        return unless respond_to?(attr) && !(password_obj = send(attr)).nil?
        ::Support::String::CharacterCounter.new.count(password_obj).each do |type, dict|
          error_string =  case type
                          when :unknown then validate_unknown(dict)
                          else validate_type(type, dict)
                          end
          errors.add(attr, error_string) if error_string.present?
        end
      end

      protected

      def validate_unknown(dict)
        type_total = dict.values.reduce(0, :+)
        return if type_total <= self.class.config[:REQUIRED_CHAR_COUNTS][:unknown][:max]

        error_string_for_unknown_chars(type_total, dict.keys)
      end

      def validate_type(type, dict)
        type_total = dict.values.reduce(0, :+)
        error_string = if type_total < self.class.config[:REQUIRED_CHAR_COUNTS][type][:min]
                         error_string_for_minimum_chars(type, type_total)
                       else
                         error_string_for_maximum_chars(type, type_total)
                       end
        error_string
      end

      def error_string_for_minimum_chars(type, total)
        count_min = self.class.config[:REQUIRED_CHAR_COUNTS][type][:min]

        return '' if total >= count_min

        LocaleTools.replace_macros(
          I18n.translate('dppe.password_content_enforcement.errors.messages.minimum_characters'),
          count: count_min,
          type: type.to_s,
          subject: 'character'.pluralize(count_min)
        ) + ' ' + dict_for_type(type)
      end

      def error_string_for_maximum_chars(type, total)
        count_max = self.class.config[:REQUIRED_CHAR_COUNTS][type][:max]

        return '' if total <= count_max

        LocaleTools.replace_macros(
          I18n.translate('dppe.password_content_enforcement.errors.messages.maximum_characters'),
          count: count_max,
          type: type.to_s,
          subject: 'character'.pluralize(count_max)
        ) + ' ' + dict_for_type(type)
      end

      def error_string_for_unknown_chars(total, chars = [])
        LocaleTools.replace_macros(
          I18n.translate('dppe.password_content_enforcement.errors.messages.unknown_characters'),
          count: total,
          subject: 'character'.pluralize(total)
        ) + " (#{chars.join('')})"
      end

      def dict_for_type(type)
        character_counter = ::Support::String::CharacterCounter.new

        case type
        when :special, :unknown then "(#{character_counter.count_hash[type].keys.join('')})"
        else
          "(#{character_counter.count_hash[type].keys.first}..#{character_counter.count_hash[type].keys.last})"
        end
      end

      module ClassMethods
        config_params = %i(
          password_required_uppercase_count
          password_required_lowercase_count
          password_required_number_count
          password_required_special_count
        )
        ::Devise::Models.config(self, *config_params)

        # rubocop:disable Metrics/MethodLength
        def config
          {
            REQUIRED_CHAR_COUNTS: {
              uppercase: {
                min: password_required_uppercase_count,
                max: Support::Math::Integer::MAX
              },
              lowercase: {
                min: password_required_lowercase_count,
                max: Support::Math::Integer::MAX
              },
              number: {
                min: password_required_number_count,
                max: Support::Math::Integer::MAX
              },
              special: {
                min: password_required_special_count,
                max: Support::Math::Integer::MAX
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
