model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :resource, :name, :values

  json.subscription model.subscription, :id, :name if model.subscription

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
