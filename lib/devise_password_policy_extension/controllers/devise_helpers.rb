module DevisePasswordPolicyExtension
  module Controllers
    module DeviseHelpers
      extend ActiveSupport::Concern

      require 'support/string/locale_tools'

      LocaleTools = ::Support::String::LocaleTools

      # rubocop:disable Style/ClassAndModuleChildren
      class ::DeviseController
        alias old_require_no_authentication require_no_authentication

        protected

        # Override the devise require_no_authentication before callback so users
        # have to prevent authenticated users with expired passwords from
        # escaping to other pages without first updating their passwords.
        def require_no_authentication
          return if check_password_expired_and_redirect!

          old_require_no_authentication
        end

        # Store the name of the current controller and action in the warden
        # session store then redirect if signed in and password expired. The
        # stored values will be used by non-devise controllers to prevent a
        # user from escaping the change password process.
        def check_password_expired_and_redirect!
          assert_is_devise_resource!

          return if skip_current_devise_controller?

          if signed_in?(scope_name) && warden.session(scope_name)[:dppe_password_expired]
            save_controller_state
            redirect_to edit_user_password_regular_update_enforcement_url, alert: "#{error_string_for_password_expired}."
            return true
          end

          false
        end

        def save_controller_state
          warden.session(scope_name)[:dppe_last_controller] = self.class.name
          warden.session(scope_name)[:dppe_last_action] = action_name
        end

        def skip_current_devise_controller?
          exclusion_list = [
            'Devise::SessionsController'
          ]
          exclusion_list.select { |e| e == "#{self.class.name}#" + action_name || e == self.class.name.to_s }.empty?
        end

        def error_string_for_password_expired
          class_obj = scope_name.to_s.camelize.constantize
          LocaleTools.replace_macros(
            I18n.translate('dppe.password_regular_update_enforcement.errors.messages.password_expired'),
            timeframe: distance_of_time_in_words(class_obj.password_maximum_age)
          )
        end
      end
      # rubocop:enable Style/ClassAndModuleChildren
    end
  end
end
