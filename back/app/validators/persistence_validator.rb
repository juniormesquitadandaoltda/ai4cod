class PersistenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, :persistence if value&.new_record?
  end
end
