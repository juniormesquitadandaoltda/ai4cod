json.partial! 'shared/admin/show', locals: {
  attributes: %i[id name email notes subscription created_at updated_at]
}

json.partial! 'model'
