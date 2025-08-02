json.partial! 'shared/admin/show', locals: {
  attributes: %i[
    id
    uuid
    email
    name
    timezone
    locale
    status
    profile
    reset_password_sent_at
    remember_created_at
    sign_in_count
    current_sign_in_at
    last_sign_in_at
    current_sign_in_ip
    last_sign_in_ip
    confirmed_at
    confirmation_sent_at
    unconfirmed_email
    failed_attempts
    locked_at
    destroyed_at
    subscriptions_count
    collaborations_count
    created_at
    updated_at
  ]
}

json.partial! 'model'
