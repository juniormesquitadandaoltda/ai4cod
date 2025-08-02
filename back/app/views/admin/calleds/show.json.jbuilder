json.partial! 'shared/admin/show', locals: {
  attributes: %i[id subject message answer subscription created_at updated_at]
}

json.partial! 'model'
