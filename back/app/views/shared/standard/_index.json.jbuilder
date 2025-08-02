json.partial! 'shared/standard/default', locals: {}

json.merge!(
  attributes: attributes.map do |attribute|
    next if %i[shared facilitator proprietor notes].include?(attribute) && controller.client?

    attribute_helper(model: controller.class::MODEL, name: attribute, listable: true, searchable: true, inputable: false, subscription: controller.current_subscription)
  end.compact,
  title: controller.class::MODEL.model_name.human(count: 2),
  paths: %i[new export].map do |action|
    next if controller.class::MODEL == ::Archive

    next unless authorized_application_helper?(controller_path, action)

    path_helper(params:, controller: controller_path, action:)
  end.compact
)
