json.partial! 'shared/standard/index', locals: {
  attributes: %i[id name stage next_stage scheduling_at shared vehicle created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :name, :stage, :next_stage, :shared

  json.scheduling_at result.scheduling_at.to_api

  json.shared result.shared unless controller.client?

  json.vehicle do
    json.id result.vehicle_id
    json.plate result.vehicle_plate
    json.paths controller.client? ? [] : [
      path_helper(params:, controller: :vehicles, action: :show, id: result.vehicle_id)
    ]
  end

  json.created_at result.created_at.to_api
  json.updated_at result.updated_at.to_api

  json.paths(%i[show edit destroy index_archives new_archives].map do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
