model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :name, :stage, :next_stage

  json.scheduling_at model.scheduling_at&.to_api

  json.extract! model, :shared, :notes unless controller.client?
  json.vehicle model.vehicle, :id, :plate if model.vehicle
  json.facilitator model.facilitator, :id, :name if model.facilitator && !controller.client?
  json.proprietor model.proprietor, :id, :name if model.proprietor && !controller.client?

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
