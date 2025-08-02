json.partial! 'shared/login/default', locals: {
  path: { title: t('login.shared.links.change'), method: 'put', url: login_registration_path }
}

json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :email, listable: false, searchable: false, inputable: false, subscription: nil),
    attribute_helper(model: controller.class::MODEL, name: :name, listable: false, searchable: false, inputable: true, subscription: nil),
    attribute_helper(model: controller.class::MODEL, name: :locale, listable: false, searchable: false, inputable: true, subscription: nil),
    attribute_helper(model: controller.class::MODEL, name: :timezone, listable: false, searchable: false, inputable: true, subscription: nil)
  ],
  title: t('login.registrations.edit.title'),
  redirect: nil
)

json.model current_user, :email, :name, :locale, :timezone
