json.partial! 'shared/admin/edit', locals: {
  attributes: %i[name actived due_date maximum_records_count]
}

json.partial! 'model'
