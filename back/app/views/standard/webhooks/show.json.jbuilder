json.partial! 'shared/standard/show', locals: {
  attributes: %i[id url actived resource event request_metadata requests_count created_at updated_at]
}

json.partial! 'model'
