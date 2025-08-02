json.partial! 'shared/login/default', locals: {
  path: { title: t('login.shared.links.request_access_token'), method: 'put', url: login_session_path }
}

json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :email, listable: false, searchable: false, inputable: true, subscription: nil),
    attribute_helper(model: controller.class::MODEL, name: :policy_terms, listable: false, searchable: false, inputable: true, subscription: nil)
  ],
  title: t('login.sessions.new.title'),
  model: {}
)
