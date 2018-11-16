module Devise
  class PasswordsWithPolicyController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    def edit
      self.resource = resource_class.new
      resource.errors.add(:base, "#{error_string_for_password_expired}.")
      render :edit
    end

    def update
      if update_resource(resource, account_update_params)
        prepare_for_redirect
        redirect_to stored_location_for(scope_name) || :root
      else
        render :edit
      end
    end

    def devise_parameter_sanitizer
      @devise_parameter_sanitizer ||= Devise::ParameterSanitizer.new(resource_class, resource_name, params)
    end

    protected

    def account_update_params
      devise_parameter_sanitizer.sanitize(:account_update)
    end

    def authenticate_scope!
      send(:"authenticate_#{scope_name}!")
      self.resource = send("current_#{scope_name}")
    end

    def alert_string_for_password_updated
      I18n.t('secure_password.password_requires_regular_updates.alerts.messages.password_updated')
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:update_action])
    end

    def error_string_for_password_expired
      return 'password expired' unless warden.user.class.respond_to?(:password_maximum_age)

      I18n.t(
        'secure_password.password_requires_regular_updates.errors.messages.password_expired',
        timeframe: precise_distance_of_time_in_words(warden.user.class.password_maximum_age)
      )
    end

    def prepare_for_redirect
      unset_devise_secure_password_expired!
      flash[:notice] = alert_string_for_password_updated
      bypass_sign_in resource, scope: scope_name
    end

    def update_resource(resource, params)
      update_action = (params[:update_action] ? params.delete(:update_action) : nil)
      return false unless update_action == 'change_password'

      update_password(resource, params)

      # do what devise would do under normal circumstances but also be aware of
      # secure_password or other validators that would be ignored by devise.
      result = if resource.errors.count.zero?
                 resource.update(params)
               else
                 false
               end

      resource.clean_up_passwords
      result
    end

    def update_password(resource, params)
      #
      # order of operations that follow is absolutely critical
      #
      current_password = params.delete(:current_password)
      current_password_valid = resource.valid_password?(current_password)

      # let our installed validator chain handle the validation work
      resource.assign_attributes(params)
      resource.valid?
      unless current_password_valid
        resource.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      end

      resource
    end
  end
end
