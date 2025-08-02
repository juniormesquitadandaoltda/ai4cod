model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :url, :headers, :body

  json.notificator model.notificator, :id, :name if model.notificator

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
