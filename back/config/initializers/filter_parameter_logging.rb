Rails.application.config.filter_parameters += %i[
  passw secret token _key crypt salt certificate otp ssn api_key access_token password password_confirmation
]
