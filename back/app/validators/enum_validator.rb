class EnumValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.class.send(attribute.to_s.pluralize).values.include?(value)
      record.send("#{attribute}_#{value}_at=", Time.current.utc.as_json) if @options[:at]

      if record.send("#{attribute}_changed?")
        @options[:transition]&.each do |key, values|
          record.errors.add(attribute, :transition) if record.send("#{attribute}_was") == key.to_s && values.exclude?(value&.to_sym)
        end
      end

      record.errors.add("#{attribute}_#{value}_reason", :blank) if @options[:reason].to_a.include?(value.to_sym) && record.send("#{attribute}_#{value}_reason").blank?

      record.errors.add("#{attribute}_#{value}_value", :blank) if @options[:value].to_a.include?(value.to_sym) && record.send("#{attribute}_#{value}_value").blank?

      record.class.stored_attributes[:"#{attribute}_value"].to_a.each do |decimal|
        current_value = record.send("#{attribute}_#{decimal}_value").presence

        if !current_value.to_s.remove(/\d/).sub('.', '').presence.nil?
          record.errors.add("#{attribute}_#{decimal}_value", :not_a_number)
        elsif current_value.present? && current_value.to_f <= 0.0
          record.errors.add("#{attribute}_#{decimal}_value", :greater_than, count: 0.0)
        else
          record.send("#{attribute}_#{decimal}_value=", current_value&.to_f)
        end
      end

      record.errors.add(attribute, :exclusion) if @options[:admin].to_a.include?(value.to_sym) && !record.current_user&.profile_admin?
    else
      record.errors.add attribute, :inclusion
    end
  end
end
