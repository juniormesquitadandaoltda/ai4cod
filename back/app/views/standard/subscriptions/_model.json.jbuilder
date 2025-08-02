model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :actived, :maximum_records_count, :current_records_count
  json.extract! model, *controller.class::MODEL.counts

  json.due_date model.due_date&.to_api
end
