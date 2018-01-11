module Devise
  class DppePasswordsController < DeviseController
    before_action :authenticate_scope!

    LocaleTools = ::Support::String::LocaleTools

    def edit
      self.resource = resource_class.new
      if warden.session(scope_name)['dppe_password_expired']
        resource.errors.add(:base, "#{error_string_for_password_expired}.")
      end
      render :edit
    end

    def update
      if resource.update_with_password(password_params)
        prepare_for_redirect
        redirect_to stored_location_for(scope_name) || :root
      else
        clean_up_passwords(resource)
        render :edit
      end
    end

    private

    def authenticate_scope!
      send(:"authenticate_#{scope_name}!")
      self.resource = send("current_#{scope_name}")
    end

    def alert_string_for_password_updated
      LocaleTools.replace_macros(
        I18n.translate('dppe.password_regular_update_enforcement.alerts.messages.password_updated')
      )
    end

    def error_string_for_password_expired
      return 'password expired' unless warden.user.class.respond_to?(:password_maximum_age)
      LocaleTools.replace_macros(
        I18n.translate('dppe.password_regular_update_enforcement.errors.messages.password_expired'),
        timeframe: distance_of_time_in_words(warden.user.class.password_maximum_age)
      )
    end

    def password_params
      params.require(scope_name).permit(:current_password, :password, :password_confirmation)
    end

    def prepare_for_redirect
      warden.session(scope_name)[:dppe_password_expired] = false
      flash[:notice] = alert_string_for_password_updated
      bypass_sign_in resource, scope: scope_name
    end
  end
end
