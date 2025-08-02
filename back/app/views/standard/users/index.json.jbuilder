json.partial! 'shared/standard/default', locals: {}

json.models @filter.results do |result|
  json.extract! result, :uuid, :email
end
json.count @filter.count

json.merge!(
  attributes: [
    attribute_helper(model: controller.class::MODEL, name: :uuid, listable: true, searchable: true, inputable: false, subscription: controller.current_subscription),
    attribute_helper(model: controller.class::MODEL, name: :email, listable: true, searchable: false, inputable: false, subscription: controller.current_subscription)
  ],
  title: controller.class::MODEL.model_name.human(count: 2)
)
