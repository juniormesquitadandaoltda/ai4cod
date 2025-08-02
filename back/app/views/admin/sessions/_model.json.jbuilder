model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :uuid, :name, :email
end

json.paths [
  { title: t('view.path.logout.title'), method: 'delete', url: login_session_path, message: t('view.path.logout.message') }
]

json.merge!(
  title: t('view.page.session.title', name: model.name)
)
