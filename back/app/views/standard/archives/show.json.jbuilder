json.partial! 'shared/standard/show', locals: {
  attributes: %i[id filename byte_size record created_at updated_at]
}

json.partial! 'model'

json.redirect @model.url(disposition: :attachment).sub('localstack', 'localhost')
