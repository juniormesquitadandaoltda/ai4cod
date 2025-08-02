json.partial! 'shared/standard/show', locals: {
  attributes: %i[
    actived due_date
    maximum_records_count
    current_records_count
  ] + controller.class::MODEL.counts
}

json.partial! 'model'
