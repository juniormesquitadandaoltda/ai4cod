json.partial! 'shared/admin/show', locals: {
  attributes: %i[id event item_id item_type object object_changes whodunnit owner created_at updated_at]
}

json.partial! 'model'
