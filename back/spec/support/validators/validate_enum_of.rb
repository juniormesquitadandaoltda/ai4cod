require 'rspec/expectations'

RSpec::Matchers.define :validate_enum_of do |attribute|
  match do |instance|
    with = options[:with].to_h

    with[:transition].to_h.each do |key, values|
      instance.update_columns(attribute => key)

      values.each do |value|
        instance.reload.assign_attributes(attribute => value)

        instance.valid?

        return false if instance.errors.details[attribute].include?(error: :transition)
        return false if instance.send("#{attribute}_#{value}_at").blank?
      end

      instance.reload.assign_attributes(attribute => 'none')
      instance.valid?
      return false unless instance.errors.details[attribute].include?(error: :inclusion)

      with[:reason].to_a.each do |reason|
        instance.reload.assign_attributes(attribute => reason, "#{attribute}_#{reason}_reason" => ' ')

        instance.valid?

        return false unless instance.errors.details[:"#{attribute}_#{reason}_reason"].include?(error: :blank)
      end

      instance.class.stored_attributes[:"#{attribute}_reason"].to_a.each do |reason|
        next if with[:reason].to_a.include?(reason)

        instance.reload.assign_attributes(attribute => reason, "#{attribute}_#{reason}_reason" => ' ')

        instance.valid?

        return false if instance.errors.details[:"#{attribute}_#{reason}_reason"].include?(error: :blank)
      end

      with[:value].to_a.each do |value|
        instance.reload.assign_attributes(attribute => value, "#{attribute}_#{value}_value" => ' ')
        instance.valid?
        return false unless instance.errors.details[:"#{attribute}_#{value}_value"].include?(error: :blank)
      end

      instance.class.stored_attributes[:"#{attribute}_value"].to_a.each do |value|
        instance.reload.assign_attributes(attribute => value, "#{attribute}_#{value}_value" => '9.9.9')
        instance.valid?
        return false unless instance.errors.details[:"#{attribute}_#{value}_value"].include?(error: :not_a_number)

        instance.reload.assign_attributes(attribute => value, "#{attribute}_#{value}_value" => 0.0)
        instance.valid?
        return false unless instance.errors.details[:"#{attribute}_#{value}_value"].include?(error: :greater_than, count: 0.0)
      end
    end

    current_user = build(:user, profile: :standard)
    with[:admin].to_a.each do |value|
      instance.reload.assign_attributes(attribute => value, current_user:)

      instance.valid?

      return false unless instance.errors.details[attribute].include?(error: :exclusion)
    end

    true
  end

  def with(object)
    options[:with] = object
    self
  end

  private

  def options
    @options ||= {}
  end
end
