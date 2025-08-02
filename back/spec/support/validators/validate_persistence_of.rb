require 'rspec/expectations'

RSpec::Matchers.define :validate_persistence_of do |attribute|
  match do |instance|
    value = instance.send(attribute).dup
    instance.send("#{attribute}=", value)

    instance.valid?

    instance.errors.details[attribute].include?(error: :persistence)
  end
end
