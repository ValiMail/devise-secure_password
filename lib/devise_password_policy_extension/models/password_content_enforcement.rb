module Devise
  module Models
    module PasswordContentEnforcement
      extend ActiveSupport::Concern

      require 'support/string/character_counter'

      LENGTH_MAX = 255

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
        return if type_total <= required_char_counts_for_type(:unknown)[:max]

        error_string_for_unknown_chars(type_total, dict.keys)
      end

      def validate_type(type, dict)
        type_total = dict.values.reduce(0, :+)
        error_string = if type_total < required_char_counts_for_type(type)[:min]
                         error_string_for_length(type, :min)
                       elsif type_total > required_char_counts_for_type(type)[:max]
                         error_string_for_length(type, :max)
                       end
        error_string
      end

      def error_string_for_length(type, threshold = :min)
        lang_key = case threshold
                   when :min then 'dppe.password_content_enforcement.errors.messages.minimum_characters'
                   when :max then 'dppe.password_content_enforcement.errors.messages.maximum_characters'
                   else return ''
                   end

        count = required_char_counts_for_type(type)[threshold]
        error_string = I18n.t(lang_key, count: count, type: type.to_s, subject: 'character'.pluralize(count))
        error_string + ' ' + dict_for_type(type)
      end

      def error_string_for_unknown_chars(total, chars = [])
        I18n.t(
          'dppe.password_content_enforcement.errors.messages.unknown_characters',
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

      def required_char_counts_for_type(type)
        self.class.config[:REQUIRED_CHAR_COUNTS][type]
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
                min: password_required_special_count,
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
