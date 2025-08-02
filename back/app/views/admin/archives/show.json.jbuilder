json.partial! 'shared/admin/show', locals: {
  attributes: %i[id filename record subscription created_at updated_at]
}

json.partial! 'model'

json.redirect @model.url(disposition: :attachment).sub('localstack', 'localhost')
