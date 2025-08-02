require 'rspec/expectations'

RSpec::Matchers.define :validate_unchange_of do |attribute|
  match do |instance|
    instance.send("#{attribute}=", nil)

    instance.valid?

    instance.errors.details[attribute].include?(error: :unchange)
  end
end
