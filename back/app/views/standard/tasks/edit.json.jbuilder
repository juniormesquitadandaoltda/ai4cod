json.partial! 'shared/standard/edit', locals: {
  attributes: %i[name stage next_stage scheduling_at shared vehicle facilitator proprietor notes]
}

json.partial! 'model'
