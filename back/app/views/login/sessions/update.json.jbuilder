json.partial! 'shared/login/default', locals: {
  path: { title: t('login.shared.links.sign_in'), method: 'post', url: login_session_path }
}

json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :password, listable: false, searchable: false, inputable: true, subscription: nil)
  ],
  title: t('login.sessions.new.title')
)

json.notice I18n.t('login.sessions.new_temp_password')
