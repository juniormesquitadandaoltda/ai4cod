json.partial! 'shared/standard/show', locals: {
  attributes: %i[id name stage next_stage scheduling_at shared vehicle facilitator proprietor notes created_at updated_at]
}

json.partial! 'model'
