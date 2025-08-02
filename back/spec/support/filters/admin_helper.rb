require 'rspec/expectations'

RSpec::Matchers.define :admin_search_attributes do |search_attributes|
  match do |instance|
    @instance = instance

    search_attributes = search_attributes.merge(
      key: search_attributes[:key].to_a + %i[id],
      timestamp: search_attributes[:timestamp].to_a + %i[created_at updated_at]
    )

    expect(search_attributes).to eq(described_class.search_attributes)

    search_attributes.each do |type, attributes|
      attributes.each do |attribute|
        send("#{type}_accessor", attribute)
      end
    end
  end

  private

  attr_reader :instance

  def key_accessor(attribute)
    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)

    instance.assign_attributes(current_user:, sort: attribute.to_s,
                               order: 'asc', page: 1, limit: 100, attribute => '')
    raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

    instance.assign_attributes(current_user:, sort: attribute.to_s,
                               order: 'asc', page: 1, limit: 100, attribute => 'a')
    raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

    instance.assign_attributes(attribute => nil)
  end

  def string_accessor(attribute)
    attribute_in = :"#{attribute}_in"

    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)
    raise "invalid accessor #{attribute_in}" unless instance.respond_to?(attribute_in)

    instance.assign_attributes(attribute => 'a', attribute_in => 'a')
    instance.valid?
    raise "#{attribute_in} should be absent" if instance.errors.details[attribute_in].exclude?(error: :present)

    instance.assign_attributes(attribute => nil, attribute_in => nil)
    [attribute, attribute_in].each do |a|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => '')
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => 'a')
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(a => nil)
    end
  end

  def text_accessor(attribute)
    string_accessor(attribute)
  end

  def enum_accessor(attribute)
    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)

    instance.assign_attributes(attribute => 'a')
    instance.valid?
    raise "#{attribute} should be included" if instance.errors.details[attribute].exclude?(error: :inclusion,
                                                                                           value: 'a')

    described_class::MODEL.send(attribute.to_s.pluralize).each_key do |value|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, attribute => '')
      raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, attribute => value)
      raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(attribute => nil)
    end
  end

  def field_enum_accessor(attribute)
    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)

    instance.assign_attributes(current_user:, sort: attribute.to_s,
                               order: 'asc', page: 1, limit: 100, attribute => '')
    raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

    instance.assign_attributes(current_user:, sort: attribute.to_s,
                               order: 'asc', page: 1, limit: 100, attribute => 'a')
    raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

    instance.assign_attributes(attribute => nil)
  end

  def boolean_accessor(attribute)
    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)

    instance.assign_attributes(attribute => 'a')
    instance.valid?
    raise "#{attribute} should be included" if instance.errors.details[attribute].exclude?(error: :inclusion,
                                                                                           value: 'a')

    %w[TRUE FALSE].each do |value|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, attribute => '')
      raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, attribute => value)
      raise "#{attribute} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(attribute => nil)
    end
  end

  def bigint_accessor(attribute)
    attribute_gt = :"#{attribute}_gt"
    attribute_gte = :"#{attribute}_gte"
    attribute_lt = :"#{attribute}_lt"
    attribute_lte = :"#{attribute}_lte"

    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)
    raise "invalid accessor #{attribute_gt}" unless instance.respond_to?(attribute_gt)
    raise "invalid accessor #{attribute_gte}" unless instance.respond_to?(attribute_gte)
    raise "invalid accessor #{attribute_lt}" unless instance.respond_to?(attribute_lt)
    raise "invalid accessor #{attribute_lte}" unless instance.respond_to?(attribute_lte)

    instance.assign_attributes(attribute => nil, attribute_gt => nil, attribute_gte => nil, attribute_lt => nil,
                               attribute_lte => nil)
    [attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte].each do |a|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => '')
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => 0)
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(a => nil)
    end
  end

  def decimal_accessor(attribute)
    attribute_gt = :"#{attribute}_gt"
    attribute_gte = :"#{attribute}_gte"
    attribute_lt = :"#{attribute}_lt"
    attribute_lte = :"#{attribute}_lte"

    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)
    raise "invalid accessor #{attribute_gt}" unless instance.respond_to?(attribute_gt)
    raise "invalid accessor #{attribute_gte}" unless instance.respond_to?(attribute_gte)
    raise "invalid accessor #{attribute_lt}" unless instance.respond_to?(attribute_lt)
    raise "invalid accessor #{attribute_lte}" unless instance.respond_to?(attribute_lte)

    instance.assign_attributes(attribute => nil, attribute_gt => nil, attribute_gte => nil, attribute_lt => nil,
                               attribute_lte => nil)
    [attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte].each do |a|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => '')
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => 0.0)
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(a => nil)
    end
  end

  def timeliness_accessor(attribute:, type:)
    attribute_gt = :"#{attribute}_gt"
    attribute_gte = :"#{attribute}_gte"
    attribute_lt = :"#{attribute}_lt"
    attribute_lte = :"#{attribute}_lte"

    raise "invalid accessor #{attribute}" unless instance.respond_to?(attribute)
    raise "invalid accessor #{attribute_gt}" unless instance.respond_to?(attribute_gt)
    raise "invalid accessor #{attribute_gte}" unless instance.respond_to?(attribute_gte)
    raise "invalid accessor #{attribute_lt}" unless instance.respond_to?(attribute_lt)
    raise "invalid accessor #{attribute_lte}" unless instance.respond_to?(attribute_lte)

    value = {
      date: '2000-01-01',
      time: '00:00:00',
      datetime: '2000-01-01 00:00:00',
      timestamp: '2000-01-01 00:00:00'
    }[type]

    instance.assign_attributes(attribute => nil, attribute_gt => nil, attribute_gte => nil, attribute_lt => nil,
                               attribute_lte => nil)
    [attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte].each do |a|
      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => '')
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(current_user:, sort: attribute.to_s,
                                 order: 'asc', page: 1, limit: 100, a => value)
      raise "#{a} should be search (#{instance.errors.messages})" unless instance.search

      instance.assign_attributes(a => nil)
    end
  end

  def date_accessor(attribute)
    timeliness_accessor(attribute:, type: :date)
  end

  def time_accessor(attribute)
    timeliness_accessor(attribute:, type: :time)
  end

  def datetime_accessor(attribute)
    timeliness_accessor(attribute:, type: :datetime)
  end

  def timestamp_accessor(attribute)
    timeliness_accessor(attribute:, type: :timestamp)
  end
end
