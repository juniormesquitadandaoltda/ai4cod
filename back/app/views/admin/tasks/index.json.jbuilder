json.partial! 'shared/admin/index', locals: {
  attributes: %i[id name stage next_stage scheduling_at shared vehicle subscription created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :name, :stage, :next_stage, :scheduling_at, :shared

  json.vehicle do
    json.id result.vehicle_id
    json.plate result.vehicle_plate
    json.paths [
      path_helper(params:, controller: :vehicles, action: :show, id: result.vehicle_id)
    ]
  end

  json.subscription do
    json.id result.subscription_id
    json.name result.subscription_name
    json.paths [
      path_helper(params:, controller: :subscriptions, action: :show, id: result.subscription_id)
    ]
  end

  json.created_at result.created_at.to_api
  json.updated_at result.updated_at.to_api

  json.paths(%i[show index_archives].map do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
