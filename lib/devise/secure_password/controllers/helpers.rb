module Devise
  module SecurePassword
    module Controllers
      module Helpers
        extend ActiveSupport::Concern

        included do
          before_action :check_secure_password_expiration_and_set_session_state
        end

        def authenticate_secure_password_expired?
          return false if devise_controller?
          session[:devise_secure_password_expired] == true
        end

        def authenticate_secure_password!
          return unless authenticate_secure_password_expired?
          redirect_to authenticate_secure_password_path, alert: "#{error_string_for_password_expired}."
        end

        def authenticate_secure_password_path
          return unless warden.user
          :"edit_#{devise_secure_password_scope}_password_with_policy"
        end

        private

        def devise_secure_password_scope
          Devise::Mapping.find_scope!(warden.user)
        end

        def error_string_for_password_expired
          I18n.t(
            'secure_password.password_requires_regular_updates.errors.messages.password_expired',
            timeframe: distance_of_time_in_words(warden.user.class.password_maximum_age)
          )
        end

        def check_secure_password_expiration_and_set_session_state
          return unless warden.authenticated?
          return if warden.session.blank?
          return unless warden_secure_password_expired?

          unset_warden_secure_password_expired!
          set_devise_secure_password_expired!
        end

        def set_devise_secure_password_expired!
          session[:devise_secure_password_expired] = true
        end

        def unset_devise_secure_password_expired!
          session.delete(:devise_secure_password_expired)
        end

        def unset_warden_secure_password_expired!
          warden.session(devise_secure_password_scope).delete('secure_password_expired')
        end

        def warden_secure_password_expired?
          warden.session(devise_secure_password_scope)['secure_password_expired'] == true
        end
      end
    end
  end
end
