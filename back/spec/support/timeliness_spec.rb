require 'rspec/expectations'

RSpec::Matchers.define :validate_datetime_of do |attribute|
  match do |instance|
    value = instance.send(attribute)

    instance.send("#{attribute}=", nil)

    instance.valid?

    (
      options[:allow_nil] && instance.errors.details[attribute].exclude?(error: :invalid_datetime, restriction: nil)
    ) || (
      !options[:allow_nil] && instance.errors.details[attribute].include?(error: :invalid_datetime, restriction: nil)
    )
  end

  def allow_nil(value = true)
    options[:allow_nil] = value
    self
  end

  private

  def options
    @options ||= {}
  end
end
