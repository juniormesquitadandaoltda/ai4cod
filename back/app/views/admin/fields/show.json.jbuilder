json.partial! 'shared/admin/show', locals: {
  attributes: %i[id resource name values subscription created_at updated_at]
}

json.partial! 'model'
