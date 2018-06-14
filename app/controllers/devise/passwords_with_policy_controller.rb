module Devise
  class PasswordsWithPolicyController < DeviseController
    before_action :authenticate_scope!

    def edit
      self.resource = resource_class.new
      resource.errors.add(:base, "#{error_string_for_password_expired}.")
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
      I18n.t('secure_password.password_requires_regular_updates.alerts.messages.password_updated')
    end

    def error_string_for_password_expired
      return 'password expired' unless warden.user.class.respond_to?(:password_maximum_age)
      I18n.t(
        'secure_password.password_requires_regular_updates.errors.messages.password_expired',
        timeframe: precise_distance_of_time_in_words(warden.user.class.password_maximum_age)
      )
    end

    def password_params
      params.require(scope_name).permit(:current_password, :password, :password_confirmation)
    end

    def prepare_for_redirect
      unset_devise_secure_password_expired!
      flash[:notice] = alert_string_for_password_updated
      bypass_sign_in resource, scope: scope_name
    end
  end
end
