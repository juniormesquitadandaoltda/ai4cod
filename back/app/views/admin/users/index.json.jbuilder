json.partial! 'shared/admin/index', locals: {
  attributes: %i[id uuid email status profile created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :uuid, :email, :status, :profile

  json.created_at result.created_at.to_api
  json.updated_at result.updated_at.to_api

  json.paths(%i[show edit personificate].map do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
