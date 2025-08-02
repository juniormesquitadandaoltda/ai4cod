model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :name, :actived, :maximum_records_count, :current_records_count
  json.extract! model, *controller.class::MODEL.counts

  json.user model.user, :uuid, :email if model.user

  json.due_date model.due_date&.to_api
  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
