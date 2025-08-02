model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :name, :stage, :next_stage, :scheduling_at, :notes, :shared

  json.vehicle model.vehicle, :id, :plate if model.vehicle
  json.facilitator model.facilitator, :id, :name if model.facilitator
  json.proprietor model.proprietor, :id, :name if model.proprietor
  json.subscription model.subscription, :id, :name if model.subscription

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
