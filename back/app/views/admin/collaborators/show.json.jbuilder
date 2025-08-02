json.partial! 'shared/admin/show', locals: {
  attributes: %i[id actived user subscription created_at updated_at]
}

json.partial! 'model'
