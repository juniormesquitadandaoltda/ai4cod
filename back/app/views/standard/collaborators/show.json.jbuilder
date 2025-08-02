json.partial! 'shared/standard/show', locals: {
  attributes: %i[id actived user created_at updated_at]
}

json.partial! 'model'
