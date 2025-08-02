class UnchangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    record.errors.add attribute, :unchange if record.persisted? && record.send("#{attribute}_changed?") && (
      (record.respond_to?("#{attribute}_was") && record.send("#{attribute}_was")) ||
      (record.respond_to?("#{attribute}_id_was") && record.send("#{attribute}_id_was"))
    )
  end
end
