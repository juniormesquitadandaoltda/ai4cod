require 'rspec/expectations'

RSpec::Matchers.define :validate_comparison_of do |attribute|
  match do |instance|
    if (equal_to = options[:equal_to])
      value = instance.send(equal_to)
      dup = value.dup
      instance.send("#{attribute}=", dup)

      instance.valid?

      return false unless instance.errors.details[attribute].include?(error: :equal_to, count: value, value: dup)
    elsif (other_than = options[:other_than])
      value = instance.send(other_than)
      instance.send("#{attribute}=", value)

      instance.valid?

      return false unless instance.errors.details[attribute].include?(error: :other_than, count: value, value:)
    end

    true
  end

  def equal_to(name)
    options[:equal_to] = name
    self
  end

  def other_than(name)
    options[:other_than] = name
    self
  end

  private

  def options
    @options ||= {}
  end
end
