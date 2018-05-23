module Devise
  module SecurePassword
    module Controllers
      module ActiveHelpers
        extend ActiveSupport::Concern
        def authenticate_secure_password_expired?
          return false if devise_controller?
          return false unless warden.authenticated?
          return false unless warden.session.present?
          warden.session['secure_password_expired'] == true
        end

        def authenticate_secure_password!
          return unless authenticate_secure_password_expired?
          redirect_to authenticate_secure_password_path, alert: "#{error_string_for_password_expired}."
        end

        def authenticate_secure_password_path
          return unless warden.user
          scope = Devise::Mapping.find_scope!(warden.user)
          :"edit_#{scope}_password_with_policy"
        end

        private

        def error_string_for_password_expired
          I18n.t(
            'secure_password.password_requires_regular_updates.errors.messages.password_expired',
            timeframe: distance_of_time_in_words(warden.user.class.password_maximum_age)
          )
        end
      end
    end
  end
end
