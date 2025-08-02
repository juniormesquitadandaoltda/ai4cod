json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :unlock_token, listable: false, searchable: false, inputable: false, subscription: nil)
  ],
  title: t('login.unlocks.edit.title')
)

json.partial! 'shared/login/default', locals: {
  path: { title: t('login.shared.links.unlock'), method: 'put', url: login_unlock_path }
}
