json.partial! 'shared/standard/default', locals: {}

json.merge!(
  attributes: attributes.map do |attribute|
    next if %i[shared facilitator proprietor notes].include?(attribute) && controller.client?

    attribute_helper(model: controller.class::MODEL, name: attribute, listable: false, searchable: false, inputable: false, subscription: controller.current_subscription)
  end.compact,
  title: controller.class::MODEL.model_name.human(count: 1),
  paths: %i[index].map do |action|
    next unless authorized_application_helper?(controller_path, action)

    path_helper(params:, controller: controller_path, action:)
  end.compact
)
