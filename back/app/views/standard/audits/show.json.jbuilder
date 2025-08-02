json.partial! 'shared/standard/show', locals: {
  attributes: %i[id event item_id item_type object_changes whodunnit created_at updated_at]
}

json.partial! 'model'
