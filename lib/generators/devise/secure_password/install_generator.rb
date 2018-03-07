# frozen_string_literal: true

module Devise
  module SecurePassword
    module Generators
      class InstallGenerator < Rails::Generators::Base
        LOCALES = %w(en).freeze

        source_root File.expand_path('../templates', __dir__)

        desc 'Creates a Devise Secure Password extension initializer and copies locale files to your application.'

        def copy_initializer
          template 'secure_password.rb', 'config/initializers/secure_password.rb'
        end

        def copy_locale
          LOCALES.each do |locale|
            copy_file "../../../../config/locales/#{locale}.yml",
                      "config/locales/secure_password.#{locale}.yml"
          end
        end

        def show_readme
          readme 'README.txt' if behavior == :invoke
        end
      end
    end
  end
end
