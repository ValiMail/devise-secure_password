# frozen_string_literal: true

module DevisePasswordPolicyExtension
  module Generators
    class InstallGenerator < Rails::Generators::Base
      LOCALES = %w(en).freeze

      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a Devise Password Policy Extension initializer and copies locale files to your application.'

      def copy_initializer
        template 'devise_password_policy_extension.rb', 'config/initializers/devise_password_policy_extension.rb'
      end

      def copy_locale
        LOCALES.each do |locale|
          copy_file "../../../config/locales/#{locale}.yml",
                    "config/locales/devise_password_policy_extension.#{locale}.yml"
        end
      end

      def show_readme
        readme 'README.txt' if behavior == :invoke
      end
    end
  end
end
