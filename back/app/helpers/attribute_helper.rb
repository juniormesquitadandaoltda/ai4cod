module AttributeHelper
  def attribute_helper(model:, name:, listable:, searchable:, inputable:, subscription:)
    type = if model.respond_to?(:"#{name.to_s.pluralize}_i18n")
             'enum'
           elsif name != :id && model.new.respond_to?(:"field_#{name.to_s.pluralize}")
             'field_enum'
           elsif model.column_names.include?("#{name}_id")
             'reference'
           elsif %i[password password_confirmation current_password access_token token].include?(name)
             'secret'
           elsif %i[remember_me].include?(name)
             'boolean'
           elsif name.end_with?('_at')
             'timestamp'
           elsif name.end_with?('_reason') || %i[filename].include?(name)
             'string'
           elsif name.end_with?('_value')
             'decimal'
           elsif model.column_for_attribute(name).sql_type == 'jsonb' && model.column_for_attribute(name).default == '[]'
             'array'
           elsif model.column_for_attribute(name).sql_type == 'jsonb'
             'json'
           elsif name == :attachments
             'attachment'
           elsif name == :byte_size
             'byte'
           else
             model.column_for_attribute(name).sql_type
           end

    type.gsub!(/character.*/, 'string')
    type.gsub!(/timestamp.*/, 'timestamp')

    {
      name: name.to_s,
      type: type.to_s,
      title: model.human_attribute_name(name),
      listable:,
      searchable:,
      inputable:
    }.merge(
      send(:"#{type}_attribute_helper", model:, name:, subscription:)
    )
  end

  private

  def uuid_attribute_helper(model:, name:, subscription:)
    {
      title: ApplicationRecord.human_attribute_name(name)
    }
  end

  def string_attribute_helper(model:, name:, subscription:)
    prefix, key, suffix = name.to_s.split('_')

    if (values = model.stored_attributes[:"#{prefix}_reason"])
      {
        title: "#{model.send("#{prefix.pluralize}_i18n")[key]} (#{ApplicationRecord.human_attribute_name(:store_reason)})"
      }
    elsif model == Vehicle && %i[year licensing].include?(name)
      {
        mask: '9999/9999'
      }
    else
      {}
    end
  end

  def text_attribute_helper(model:, name:, subscription:)
    {}
  end

  def enum_attribute_helper(model:, name:, subscription:)
    {
      enum: model.send("#{name.to_s.pluralize}_i18n").map { |key, value| { value: key, title: value } }
    }
  end

  def field_enum_attribute_helper(model:, name:, subscription:)
    {
      enum: model.new(subscription:).send(:"field_#{name.to_s.pluralize}").map { |value| { value:, title: value } }
    }
  end

  def boolean_attribute_helper(model:, name:, subscription:)
    {}
  end

  def bigint_attribute_helper(model:, name:, subscription:)
    return {} if %i[id].exclude?(name)

    {
      title: ApplicationRecord.human_attribute_name(name)
    }
  end

  def date_attribute_helper(model:, name:, subscription:)
    {}
  end

  def timestamp_attribute_helper(model:, name:, subscription:)
    prefix, key, suffix = name.to_s.split('_')

    if (values = model.stored_attributes[:"#{prefix}_at"])
      {
        title: "#{model.send("#{prefix.pluralize}_i18n")[key]} (#{ApplicationRecord.human_attribute_name(:store_at)})"
      }
    elsif %i[created_at updated_at].include?(name)
      {
        title: ApplicationRecord.human_attribute_name(name)
      }
    else
      {}
    end
  end

  def reference_attribute_helper(model:, name:, subscription:)
    name = name.to_s
    name.gsub!('whodunnit', 'user')
    name.gsub!('owner', 'user')
    name.gsub!('record', 'archive')

    reference = name.classify.constantize

    field = {
      User: :email,
      Vehicle: :plate,
      Archive: :type
    }.dig(reference.to_s.to_sym) || :name

    key = {
      User: :uuid,
      Vehicle: :plate
    }.dig(reference.to_s.to_sym) || :id

    {
      paths: [
        path_helper(params: {}, controller: reference.model_name.collection, action: :index)
      ],
      reference: { name: field.to_s, type: 'string', title: reference.human_attribute_name(field), key: }
    }
  end

  def json_attribute_helper(model:, name:, subscription:)
    {}
  end

  def array_attribute_helper(model:, name:, subscription:)
    {}
  end

  def integer_attribute_helper(model:, name:, subscription:)
    {}
  end

  def decimal_attribute_helper(model:, name:, subscription:)
    prefix, key, suffix = name.to_s.split('_')

    if (values = model.stored_attributes[:"#{prefix}_value"])
      {
        title: "#{model.send("#{prefix.pluralize}_i18n")[key]} (#{ApplicationRecord.human_attribute_name(:store_value)})"
      }
    else
      {}
    end
  end

  def secret_attribute_helper(model:, name:, subscription:)
    {}
  end

  def attachment_attribute_helper(model:, name:, subscription:)
    {}
  end

  def byte_attribute_helper(model:, name:, subscription:)
    {
      searchable: false,
      inputable: false
    }
  end
end
