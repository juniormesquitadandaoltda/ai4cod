json.partial! 'shared/admin/index', locals: {
  attributes: %i[id event item_id item_type whodunnit owner created_at updated_at]
}

json.models @filter.results do |result|
  json.extract! result, :id, :event, :item_id, :item_type

  json.whodunnit do
    json.uuid result.whodunnit_uuid
    json.email result.whodunnit_email
    json.paths [
      path_helper(params:, controller: :users, action: :show, id: result.whodunnit_id)
    ]
  end

  json.owner do
    json.uuid result.owner_uuid
    json.email result.owner_email
    json.paths [
      path_helper(params:, controller: :users, action: :show, id: result.owner_id)
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
