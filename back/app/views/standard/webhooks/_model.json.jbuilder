model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :url, :actived, :resource, :event, :request_metadata, :requests_count

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
