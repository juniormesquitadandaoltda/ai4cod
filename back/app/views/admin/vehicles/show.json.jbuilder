json.partial! 'shared/admin/show', locals: {
  attributes: %i[id chassis year brand model color fuel category kind seats plate renavam licensing notes subscription created_at updated_at]
}

json.partial! 'model'
