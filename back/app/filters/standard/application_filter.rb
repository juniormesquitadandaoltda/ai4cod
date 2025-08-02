module STANDARD
  class ApplicationFilter
    include ::ActiveModel::Model

    attr_accessor :sort, :order, :page, :limit, :current_user, :current_subscription
    attr_reader :results, :count

    validates :sort, presence: true, inclusion: { in: :sortables }
    validates :order, presence: true, inclusion: { in: %w[asc desc] }
    validates :page, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :limit, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
    validates :current_user, presence: true

    def search
      return false if invalid?

      @results = from

      self.class.search_attributes.each do |type, columns|
        columns.each { |column| send "where_#{type}!", column }
      end

      @count = @results.count
      @results = @results.order(sort => order).offset((page.to_i - 1) * limit.to_i).limit(limit.to_i)
      @results = @results.select(self.select).to_a

      true
    end

    def self.search_attributes(search_attributes = {
      key: [],
      string: [],
      text: [],
      enum: [],
      field_enum: [],
      boolean: [],
      bigint: [],
      decimal: [],
      date: [],
      time: [],
      datetime: [],
      timestamp: []
    })
      return @search_attributes if @search_attributes

      @search_attributes = search_attributes.merge(
        key: search_attributes[:key].to_a + %i[id],
        timestamp: search_attributes[:timestamp].to_a + %i[created_at updated_at]
      )

      @search_attributes.each do |type, columns|
        columns.each { |column| send "#{type}_accessor", column }
      end
    end

    def sortables
      @sortables ||= self.class.search_attributes.values.flatten.map(&:to_s)
    end

    private

    def column_names
      self.class::MODEL.column_names.map { |cn| [self.class::MODEL.table_name, cn].join('.') }
    end

    def from
      self.class::MODEL.from("(#{sql}) AS #{self.class::MODEL.table_name}")
    end

    class << self
      def key_accessor(attribute)
        attr_accessor attribute
      end

      def string_accessor(attribute)
        attribute_in = :"#{attribute}_in"

        attr_accessor attribute, attribute_in

        validates attribute_in, absence: true, if: attribute
      end

      def text_accessor(attribute)
        string_accessor attribute
      end

      def enum_accessor(attribute)
        attr_accessor attribute

        validates attribute, allow_blank: true, inclusion: { in: self::MODEL.send(attribute.to_s.pluralize).keys }

        define_method(attribute) { instance_variable_get(:"@#{attribute}")&.downcase }
      end

      def field_enum_accessor(attribute)
        attr_accessor attribute

        validates attribute, presence: false

        define_method(attribute) { instance_variable_get(:"@#{attribute}")&.downcase }
      end

      def boolean_accessor(attribute)
        attr_accessor attribute

        validates attribute, allow_blank: true, inclusion: { in: %w[true false] }

        define_method(attribute) { instance_variable_get(:"@#{attribute}")&.downcase }
      end

      def bigint_accessor(attribute)
        attribute_gt = :"#{attribute}_gt"
        attribute_gte = :"#{attribute}_gte"
        attribute_lt = :"#{attribute}_lt"
        attribute_lte = :"#{attribute}_lte"

        attr_accessor attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte

        validates attribute, allow_blank: true, numericality: { only_integer: true }

        validates attribute_gt, allow_blank: true, numericality: { only_integer: true }
        validates attribute_gte, allow_blank: true, numericality: { only_integer: true }
        validates attribute_lt, allow_blank: true, numericality: { only_integer: true }
        validates attribute_lte, allow_blank: true, numericality: { only_integer: true }

        validates attribute_gt, numericality: { less_than: attribute_lt }, if: lambda {
                                                                                 send(attribute_gt).present? && send(attribute_lt).present?
                                                                               }
        validates attribute_gte, numericality: { less_than: attribute_lte }, if: lambda {
                                                                                   send(attribute_gte).present? && send(attribute_lte).present?
                                                                                 }
        validates attribute_lt, numericality: { greater_then: attribute_gt }, if: lambda {
                                                                                    send(attribute_lt).present? && send(attribute_gt).present?
                                                                                  }
        validates attribute_lte, numericality: { greater_then: attribute_gte }, if: lambda {
                                                                                      send(attribute_lte).present? && send(attribute_gte).present?
                                                                                    }

        validates attribute_gt, absence: true, if: attribute
        validates attribute_gte, absence: true, if: -> { send(attribute).present? || send(attribute_gt).present? }
        validates attribute_lt, absence: true, if: attribute
        validates attribute_lte, absence: true, if: -> { send(attribute).present? || send(attribute_lt).present? }
      end

      def decimal_accessor(attribute)
        attribute_gt = :"#{attribute}_gt"
        attribute_gte = :"#{attribute}_gte"
        attribute_lt = :"#{attribute}_lt"
        attribute_lte = :"#{attribute}_lte"

        attr_accessor attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte

        validates attribute, allow_blank: true, numericality: true

        validates attribute_gt, allow_blank: true, numericality: true
        validates attribute_gte, allow_blank: true, numericality: true
        validates attribute_lt, allow_blank: true, numericality: true
        validates attribute_lte, allow_blank: true, numericality: true

        validates attribute_gt, numericality: { less_than: attribute_lt }, if: lambda {
                                                                                 send(attribute_gt).present? && send(attribute_lt).present?
                                                                               }
        validates attribute_gte, numericality: { less_than: attribute_lte }, if: lambda {
                                                                                   send(attribute_gte).present? && send(attribute_lte).present?
                                                                                 }
        validates attribute_lt, numericality: { greater_then: attribute_gt }, if: lambda {
                                                                                    send(attribute_lt).present? && send(attribute_gt).present?
                                                                                  }
        validates attribute_lte, numericality: { greater_then: attribute_gte }, if: lambda {
                                                                                      send(attribute_lte).present? && send(attribute_gte).present?
                                                                                    }

        validates attribute_gt, absence: true, if: attribute
        validates attribute_gte, absence: true, if: -> { send(attribute).present? || send(attribute_gt).present? }
        validates attribute_lt, absence: true, if: attribute
        validates attribute_lte, absence: true, if: -> { send(attribute).present? || send(attribute_lt).present? }
      end

      def timeliness_accessor(attribute:, type:)
        attribute_gt = :"#{attribute}_gt"
        attribute_gte = :"#{attribute}_gte"
        attribute_lt = :"#{attribute}_lt"
        attribute_lte = :"#{attribute}_lte"

        attr_accessor attribute, attribute_gt, attribute_gte, attribute_lt, attribute_lte

        validates attribute, allow_blank: true, timeliness: { type: }

        validates attribute_gt, allow_blank: true, timeliness: { type: }
        validates attribute_gte, allow_blank: true, timeliness: { type: }
        validates attribute_lt, allow_blank: true, timeliness: { type: }
        validates attribute_lte, allow_blank: true, timeliness: { type: }

        validates attribute_gt, timeliness: { on_or_before: attribute_lt, type: }, if: lambda {
                                                                                         send(attribute_gt).present? && send(attribute_lt).present?
                                                                                       }
        validates attribute_gte, timeliness: { on_or_before: attribute_lte, type: }, if: lambda {
                                                                                           send(attribute_gte).present? && send(attribute_lte).present?
                                                                                         }
        validates attribute_lt, timeliness: { on_or_after: attribute_gt, type: }, if: lambda {
                                                                                        send(attribute_lt).present? && send(attribute_gt).present?
                                                                                      }
        validates attribute_lte, timeliness: { on_or_after: attribute_gte, type: }, if: lambda {
                                                                                          send(attribute_lte).present? && send(attribute_gte).present?
                                                                                        }

        validates attribute_gt, absence: true, if: attribute
        validates attribute_gte, absence: true, if: -> { send(attribute).present? || send(attribute_gt).present? }
        validates attribute_lt, absence: true, if: attribute
        validates attribute_lte, absence: true, if: -> { send(attribute).present? || send(attribute_lt).present? }
      end

      def date_accessor(attribute)
        timeliness_accessor attribute:, type: :date
      end

      def time_accessor(attribute)
        timeliness_accessor attribute:, type: :time
      end

      def datetime_accessor(attribute)
        timeliness_accessor attribute:, type: :datetime
      end

      def timestamp_accessor(attribute)
        timeliness_accessor attribute:, type: :timestamp
      end
    end

    def where_key!(attribute)
      unless (value = send attribute).nil?
        @results = if value == ''
                     @results.where attribute => nil
                   elsif attribute.to_s.ends_with?('uuid')
                     @results.where "#{attribute}::TEXT = ?", value
                   else
                     @results.where attribute => value
                   end
      end
    end

    def where_string!(attribute)
      unless (value = send attribute).nil?
        @results = if value == ''
                     @results.where attribute => nil
                   else
                     @results.where attribute => value
                   end
      end

      unless (value = send "#{attribute}_in").to_s.empty?
        sanitize_sql_like = ApplicationRecord.sanitize_sql_like value
        @results = @results.where "searchable_#{attribute} LIKE (UNACCENT(LOWER(?)))", "%#{value}%"
      end
    end

    def where_text!(attribute)
      where_string! attribute
    end

    def where_enum!(attribute)
      where_key! attribute
    end

    def where_field_enum!(attribute)
      where_key! attribute
    end

    def where_boolean!(attribute)
      where_key! attribute
    end

    def where_bigint!(attribute)
      unless (value = send attribute).nil?
        @results = if value == ''
                     @results.where attribute => nil
                   else
                     @results.where attribute => value
                   end
      end

      { gt: '>', gte: '>=', lt: '<', lte: '<=' }.each do |suffix, operator|
        unless (value = send "#{attribute}_#{suffix}").to_s.empty?
          @results = @results.where "#{attribute} #{operator} ?", value
        end
      end
    end

    def where_decimal!(attribute)
      where_bigint! attribute
    end

    def where_timeliness!(attribute:, type:)
      parser = {
        date: 'DATE',
        time: 'TIME',
        datetime: 'TIMESTAMP',
        timestamp: 'TIMESTAMP'
      }[type]

      unless (value = send attribute).nil?
        @results = if value == ''
                     @results.where attribute => nil
                   else
                     @results.where "DATE_TRUNC('second', #{attribute})::#{parser} = ?", value.in_time_zone
                   end
      end

      { gt: '>', gte: '>=', lt: '<', lte: '<=' }.each do |suffix, operator|
        unless (value = send "#{attribute}_#{suffix}").to_s.empty?
          @results = @results.where "DATE_TRUNC('second', #{attribute})::#{parser} #{operator} ?", value.in_time_zone
        end
      end
    end

    def where_date!(attribute)
      where_timeliness! attribute:, type: :date
    end

    def where_time!(attribute)
      where_timeliness! attribute:, type: :time
    end

    def where_datetime!(attribute)
      where_timeliness! attribute:, type: :datetime
    end

    def where_timestamp!(attribute)
      where_timeliness! attribute:, type: :timestamp
    end
  end
end
