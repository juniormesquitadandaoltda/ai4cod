json.partial! 'shared/admin/show', locals: {
  attributes: %i[
    id name actived due_date user
    maximum_records_count
    current_records_count
  ] + controller.class::MODEL.counts + %i[created_at updated_at]
}

json.partial! 'model'
