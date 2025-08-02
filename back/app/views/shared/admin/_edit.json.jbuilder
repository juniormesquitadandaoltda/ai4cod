json.partial! 'shared/admin/default', locals: {}

json.merge!(
  attributes: attributes.map do |attribute|
    attribute_helper(model: controller.class::MODEL, name: attribute, listable: false, searchable: false, inputable: true, subscription: nil)
  end,
  title: controller.class::MODEL.model_name.human(count: 1),
  paths: %i[index update].map do |action|
    next unless authorized_application_helper?(controller_path, action)

    path_helper(params:, controller: controller_path, action:)
  end.compact
)
