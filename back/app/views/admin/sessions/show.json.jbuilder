json.partial! 'shared/admin/show', locals: {
  attributes: %i[uuid name email]
}

json.partial! 'model'
