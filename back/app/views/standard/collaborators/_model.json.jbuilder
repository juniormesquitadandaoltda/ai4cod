model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :actived
  json.user model.user, :uuid, :email if model.user

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
