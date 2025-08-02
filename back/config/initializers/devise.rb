Devise.setup do |config|
  config.parent_controller = 'Login::ApplicationController'

  config.mailer_sender = 'dont.reply@ai4cod.com'

  config.mailer = 'Login::Mailer'

  config.parent_mailer = 'ApplicationMailer'

  require 'devise/orm/active_record'

  config.authentication_keys = %i[email]

  config.request_keys = []

  config.case_insensitive_keys = %i[email]

  config.strip_whitespace_keys = %i[email]

  config.params_authenticatable = true

  config.http_authenticatable = false

  config.http_authenticatable_on_xhr = true

  config.http_authentication_realm = 'Application'

  config.paranoid = true

  config.skip_session_storage = %i[http_auth]

  config.clean_up_csrf_token_on_authentication = true

  config.reload_routes = true

  config.stretches = Rails.env.test? ? 1 : 12

  config.send_email_changed_notification = true

  config.send_password_change_notification = true

  config.allow_unconfirmed_access_for = 0.days

  config.confirm_within = 72.hours

  config.reconfirmable = true

  config.confirmation_keys = %i[email]

  config.remember_for = 72.hours

  config.expire_all_remember_me_on_sign_out = true

  config.extend_remember_period = false

  config.rememberable_options = { secure: true }

  config.password_length = 8..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.timeout_in = 72.hours

  config.lock_strategy = :failed_attempts

  config.unlock_keys = %i[email]

  config.unlock_strategy = :email

  config.maximum_attempts = 5

  config.unlock_in = 72.hours

  config.last_attempt_warning = true

  config.reset_password_keys = %i[email]

  config.reset_password_within = 72.hours

  config.sign_in_after_reset_password = false

  config.scoped_views = false

  config.default_scope = :user

  config.sign_out_all_scopes = true

  config.navigational_formats = %i[json]

  config.sign_out_via = :delete

  config.sign_in_after_change_password = false
end

require 'devise'

module Devise
  def self.friendly_token(length = 128)
    # rlength = (length * 3) / 4
    # SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    SecureRandom.base58(length)
  end
end
