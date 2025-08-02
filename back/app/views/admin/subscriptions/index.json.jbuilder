json.partial! 'shared/admin/index', locals: {
  attributes: %i[id name actived user due_date created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :name, :actived

  json.user do
    json.uuid result.user_uuid
    json.email result.user_email
    json.paths [
      path_helper(params:, controller: :users, action: :show, id: result.user_id)
    ]
  end

  json.due_date result.due_date.to_api
  json.created_at result.created_at.to_api
  json.updated_at result.updated_at.to_api

  json.paths(%i[show edit destroy].map do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
