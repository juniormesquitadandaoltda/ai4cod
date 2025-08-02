json.partial! 'shared/admin/index', locals: {
  attributes: %i[id filename record subscription created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :filename

  json.record do
    json.id result.record_id
    json.type result.record_type
    json.paths [
      path_helper(
        params:,
        controller: result.record_type.downcase.pluralize.to_sym,
        action: :show,
        id: result.record_id
      )
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

  json.paths(%i[show].map  do |action|
    next unless authorized_application_helper?(controller_path, action, id: result.id)

    path_helper(params:, controller: controller_path, action:, id: result.id)
  end.compact)
end

json.count @filter.count
