require 'rspec/expectations'

RSpec::Matchers.define :validate_field_enum_of do |attribute|
  match do |instance|
    validate_inclusion_of(attribute).in_array(
      instance.send(:"field_#{attribute.to_s.pluralize}")
    )
  end
end
