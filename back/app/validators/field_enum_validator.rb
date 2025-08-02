class FieldEnumValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ActiveModel::Validations::InclusionValidator.new(
      attributes: attribute,
      in: :"field_#{attribute.to_s.pluralize}"
    ).validate_each(record, attribute, value)
  end
end
