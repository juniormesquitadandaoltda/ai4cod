json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :email, listable: false, searchable: false, inputable: true, subscription: nil)
  ],
  title: t('login.unlocks.new.title')
)

json.partial! 'shared/login/default', locals: {
  path: { title: t('login.shared.links.request'), method: 'post', url: login_unlock_path }
}
