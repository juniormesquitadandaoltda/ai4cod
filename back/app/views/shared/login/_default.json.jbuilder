paths = [path]
if !current_user
  paths << { title: t('login.shared.links.sign_in'), method: 'get', url: new_login_session_path } if controller_name != 'sessions'
  paths << { title: t('login.shared.links.back'), method: 'GET', url: new_login_session_path } if controller_name == 'sessions' && action_name == 'update'
  # paths << { title: t('login.shared.links.sign_up'), method: 'get', url: new_login_registration_path } if devise_mapping.registerable? && controller_name != 'registrations'
  # paths << { title: t('login.shared.links.forgot_your_password'), method: 'get', url: new_login_password_path } if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations'
  # paths << { title: t('login.shared.links.didn_t_receive_confirmation_instructions'), method: 'get', url: new_login_confirmation_path } if devise_mapping.confirmable? && controller_name != 'confirmations'
  paths << { title: t('login.shared.links.didn_t_receive_unlock_instructions'), method: 'get', url: new_login_unlock_path } if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks'

  if devise_mapping.omniauthable?
    resource_class.omniauth_providers.each do |provider|
      paths << { title: t('login.shared.links.sign_in_with_provider', provider: OmniAuth::Utils.camelize(provider)), method: 'post', url: omniauth_authorize_path(resource_name, provider) }
    end
  end
elsif devise_mapping.registerable? && controller_name == 'registrations'
  paths << { title: t('login.shared.links.cancel_my_account'), method: 'delete', url: login_registration_path, message: t('login.shared.links.are_you_sure') }
end
json.paths paths

redirect = current_user.profile_admin? ? admin_session_path : standard_session_path if current_user

pages = [
  { title: 'Home', method: 'get', url: '/' },
  current_user ? { title: t('view.page.session.title'), method: 'get', url: redirect } : { title: 'Login', method: 'get', url: '/login/session/new' }
]
pages.unshift(title: 'Mail', method: 'get', url: letter_opener_web_path, target: '_blank') if Rails.env.development?

json.pages pages
json.locale I18n.locale.to_s
json.timezone Time.zone.name
json.authenticity_token form_authenticity_token
json.redirect redirect
json.set! :error, {}
json.how_to I18n.t!("how_to.#{controller_path}.#{action_name}") if controller_name == 'registrations'
