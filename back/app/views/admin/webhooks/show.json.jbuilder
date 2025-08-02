json.partial! 'shared/admin/show', locals: {
  attributes: %i[id url actived resource event request_metadata requests_count requested_at subscription created_at updated_at]
}

json.partial! 'model'
