module Devise
  module SecurePassword
    module Controllers
      module ActiveHelpers
        extend ActiveSupport::Concern

        included do
          before_action :pending_password_expired_redirect!, except: [:destroy]
        end

        # Redirect to password change page if password needs to be changed.
        def pending_password_expired_redirect!
          return unless skip_current_controller? && redirected_in_session? && warden.session&.[]('secure_password_expired')
          redirect_to edit_user_password_with_policy_url, alert: "#{error_string_for_password_expired}."
        end

        def redirected_in_session?
          warden.authenticated? && ['Devise::SessionsController', nil].include?(warden.session['secure_password_last_controller'])
        end

        # Prevent infinite loops and allow specified controllers to bypass.
        # @NOTE: The ability to extend this list may be made public, in the
        # future if that functionality is needed.
        def skip_current_controller?
          exclusion_list = [
            'Devise::SessionsController',
            'Devise::PasswordsWithPolicyController#edit',
            'Devise::PasswordsWithPolicyController#update',
            'DeviseInvitable::RegistrationsController#edit',
            'DeviseInvitable::RegistrationsController#update',
            'Devise::DeviseAuthyController#POST_verify_authy'
          ]
          !(exclusion_list.include?("#{self.class.name}#" + action_name) || (exclusion_list & self.class.ancestors.map(&:to_s)).any?)
        end

        def error_string_for_password_expired
          return 'password expired' unless warden.user.class.respond_to?(:password_maximum_age)
          I18n.t(
            'secure_password.password_requires_regular_updates.errors.messages.password_expired',
            timeframe: distance_of_time_in_words(warden.user.class.password_maximum_age)
          )
        end
      end
    end
  end
end
