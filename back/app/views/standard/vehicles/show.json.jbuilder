json.partial! 'shared/standard/show', locals: {
  attributes: %i[id chassis year brand model color fuel category kind seats plate renavam licensing notes created_at updated_at]
}

json.partial! 'model'
