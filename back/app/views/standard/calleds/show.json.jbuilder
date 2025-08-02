json.partial! 'shared/standard/show', locals: {
  attributes: %i[id subject message answer created_at updated_at]
}

json.partial! 'model'
