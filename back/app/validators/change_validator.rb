class ChangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return if record.new_record? ||
              !record.send("#{attribute}_changed?") ||
              record.send(options[:with])

    record.errors.add attribute, :unchange
  end
end
