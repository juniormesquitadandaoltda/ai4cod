module Login
  class SessionsController < ::Devise::SessionsController
    before_action :configure_sign_up_params, only: :update
    before_action :configure_sign_in_params, only: :create

    def create
      self.resource = warden.authenticate(auth_options)

      if resource

        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
      elsif (email = sign_in_params[:email].presence) && (password = sign_in_params[:password].presence)
        attempts = session[:email] == email ? session[:attempts].to_i : 0
        attempts += 1

        session[:email] = email
        session[:attempts] = attempts

        message = if attempts == Devise.maximum_attempts - 1
                    :last_attempt
                  elsif attempts >= Devise.maximum_attempts
                    :locked
                  end

        set_flash_message!(:alert, message) if message

        self.resource = User.new
        resource.errors.add(:base, :invalid_login)

      else

        self.resource = User.new
        resource.errors.add(:email, :blank) if sign_in_params[:email].blank?
        resource.errors.add(:password, :blank) if sign_in_params[:password].blank?

      end

      respond_with resource
    end

    def update
      resource = User.find_by(
        email: sign_up_params[:email]
      ) || resource_class.new_with_session(
        sign_up_params, session
      )

      PaperTrail.request.whodunnit = resource

      if resource.update(policy_terms: sign_up_params[:policy_terms])
        resource.touch(:access_sent_at)
        if resource.confirmed?
          # if %w[development test].include?(Rails.env) || resource.access_sent_at < 3.minutes.ago || (resource.last_sign_in_at && resource.last_sign_in_at > resource.access_sent_at)
          # resource.touch(:access_sent_at)
          resource.send_reset_password_instructions
          # end
        else
          # resource.touch(:access_sent_at)
          resource_class.confirm_by_token(resource.confirmation_token)
        end
      end

      respond_with resource
    end

    def destroy
      session[:personification_id] ? session.delete(:personification_id) : super
    end

    private

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[email policy_terms])
    end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    end

    def sign_up_params
      sign_up = devise_parameter_sanitizer.sanitize(:sign_up)

      sign_up.merge(
        email: sign_up[:email].to_s.downcase.delete(' ').presence
      )
    end

    def sign_in_params
      sign_in = devise_parameter_sanitizer.sanitize(:sign_in)

      sign_in.merge(
        email: sign_in[:email].to_s.downcase.delete(' ').presence,
        password: sign_in[:password].to_s.delete(' ').presence
      )
    end

    def set_flash_message!(key, kind, options = {})
      options.merge!(now: true, scope: 'login.sessions')
      super(key, kind, options)
    end
  end
end
