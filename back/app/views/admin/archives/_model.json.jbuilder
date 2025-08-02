model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :filename

  json.subscription model.subscription, :id, :name if model.subscription

  json.record do
    json.id model.record_id
    json.type model.record_type
  end

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
