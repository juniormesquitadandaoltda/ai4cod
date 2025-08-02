json.partial! 'shared/standard/default', locals: {}

json.merge!(
  attributes: attributes.map do |attribute|
    inputable = controller.class::MODEL != ::Archive || %i[record].exclude?(attribute)

    attribute_helper(model: controller.class::MODEL, name: attribute, listable: false, searchable: false, inputable:, subscription: controller.current_subscription)
  end,
  title: controller.class::MODEL.model_name.human(count: 1),
  paths: %i[index create].map do |action|
    next if controller.class::MODEL == ::Archive && action == :index

    next unless authorized_application_helper?(controller_path, action)

    path_helper(params:, controller: controller_path, action:)
  end.compact
)
