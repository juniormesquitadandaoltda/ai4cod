module Associations
  module Vehicle
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail only: %i[
        chassis
        year
        brand
        model
        color
        fuel
        category
        kind
        seats
        plate
        renavam
        licensing
      ]

      belongs_to :subscription, counter_cache: true

      has_many :tasks, dependent: :restrict_with_error

      has_many_attached :archives, dependent: :purge
    end
  end
end
