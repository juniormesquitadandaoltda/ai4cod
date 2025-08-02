json.model do
  json.extract! @model, :id

  json.notificator do
    json.extract! @model.notificator, :id, :name
  end

  json.created_at @model.created_at&.to_api
  json.updated_at @model.updated_at&.to_api
end
