module DevisePasswordPolicyExtension
  module Controllers
    module ActiveHelpers
      extend ActiveSupport::Concern

      included do
        before_action :pending_password_expired_redirect!, except: [:destroy]
      end

      # Redirect to password change page if password needs to be changed.
      def pending_password_expired_redirect!
        return unless skip_current_controller? && redirected_in_session? && warden.session && warden.session['dppe_password_expired']
        redirect_to edit_user_password_with_policy_url, alert: "#{error_string_for_password_expired}."
      end

      def redirected_in_session?
        warden.authenticated? && warden.session['dppe_last_controller'] == 'Devise::SessionsController'
      end

      def skip_current_controller?
        exclusion_list = [
          'Devise::SessionsController',
          'Devise::PasswordsWithPolicyController#edit',
          'Devise::PasswordsWithPolicyController#update'
        ]
        exclusion_list.select { |e| e == "#{self.class.name}#" + action_name || e == self.class.name.to_s }.empty?
      end

      def error_string_for_password_expired
        return 'password expired' unless warden.user.class.respond_to?(:password_maximum_age)
        I18n.t(
          'dppe.password_regular_update_enforcement.errors.messages.password_expired',
          timeframe: distance_of_time_in_words(warden.user.class.password_maximum_age)
        )
      end
    end
  end
end
