json.partial! 'shared/admin/new', locals: {
  attributes: %i[name actived due_date user maximum_records_count]
}

json.partial! 'model'
