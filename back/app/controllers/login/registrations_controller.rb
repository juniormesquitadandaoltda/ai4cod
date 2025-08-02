module Login
  class RegistrationsController < ::Devise::RegistrationsController
    before_action :configure_account_update_params, only: :update

    private

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name locale timezone])
    end

    def account_update_params
      devise_parameter_sanitizer.sanitize(:account_update).merge(
        current_password: resource.generate_temp_password
      )
    end

    def after_update_path_for(_resource)
      raise SkipRedirectsException
    end

    def set_flash_message!(key, kind, options = {})
      options.merge!(now: true, scope: 'login.registrations')
      super(key, kind, options)
    end
  end
end
