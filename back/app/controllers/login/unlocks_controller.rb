module Login
  class UnlocksController < ::Devise::UnlocksController
    def edit; end

    def update
      self.resource = resource_class.unlock_access_by_token(params.dig(:user, :unlock_token))

      yield resource if block_given?

      if resource.errors[:unlock_token].empty?
        session[:attempts] = 0 if session[:email] == resource.email

        set_flash_message!(:notice, :unlocked)
        resource.errors.clear
      end

      respond_with resource
    end

    private

    def successfully_sent?(resource)
      if resource.email.present?
        super(resource)
      else
        false
      end
    end

    def after_sending_unlock_instructions_path_for(_resource)
      raise SkipRedirectsException
    end

    def after_unlock_path_for(_resource)
      raise SkipRedirectsException
    end

    def set_flash_message!(key, kind, options = {})
      options.merge!(now: true, scope: 'login.unlocks')
      super(key, kind, options)
    end
  end
end
