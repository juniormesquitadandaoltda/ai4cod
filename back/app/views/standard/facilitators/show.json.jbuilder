json.partial! 'shared/standard/show', locals: {
  attributes: %i[id name email notes created_at updated_at]
}

json.partial! 'model'
