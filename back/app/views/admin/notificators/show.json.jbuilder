json.partial! 'shared/admin/show', locals: {
  attributes: %i[id name actived notifications_count token created_at updated_at]
}

json.partial! 'model'
