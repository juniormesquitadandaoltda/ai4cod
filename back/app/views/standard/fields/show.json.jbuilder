json.partial! 'shared/standard/show', locals: {
  attributes: %i[id resource name values created_at updated_at]
}

json.partial! 'model'
