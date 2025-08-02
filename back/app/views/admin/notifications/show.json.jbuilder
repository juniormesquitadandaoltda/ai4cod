json.partial! 'shared/admin/show', locals: {
  attributes: %i[id url headers body notificator created_at updated_at]
}

json.partial! 'model'
