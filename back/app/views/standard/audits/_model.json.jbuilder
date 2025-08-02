model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :event, :item_id, :item_type, :object_changes

  json.whodunnit model.whodunnit, :uuid, :email if model.whodunnit

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
