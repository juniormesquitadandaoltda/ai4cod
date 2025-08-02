require 'rspec/expectations'

RSpec::Matchers.define :validate_change_of do |attribute|
  match do |instance|
    if (with = options[:with])
      value = instance.send(attribute)
      instance.send("#{attribute}=", value.is_a?(String) ? value.reverse : nil)

      expect(instance).to receive(with).at_least(1).and_return(false)

      instance.valid?

      return false unless instance.errors.details[attribute].include?(error: :unchange)
    end

    true
  end

  def with(name)
    options[:with] = name
    self
  end

  private

  def options
    @options ||= {}
  end
end
