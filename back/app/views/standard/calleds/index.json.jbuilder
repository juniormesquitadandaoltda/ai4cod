json.partial! 'shared/standard/index', locals: {
  attributes: %i[id subject created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :subject

  json.created_at result.created_at.to_api
  json.updated_at result.updated_at.to_api

  json.paths(%i[show edit destroy].map do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
