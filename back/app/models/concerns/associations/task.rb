module Associations
  module Task
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail only: %i[
        name
        stage
        next_stage
        scheduling_at
        shared
        vehicle_id
        facilitator_id
        proprietor_id
      ], limit: nil

      belongs_to :subscription, counter_cache: true
      belongs_to :vehicle
      belongs_to :facilitator, optional: true
      belongs_to :proprietor, optional: true

      has_many_attached :archives, dependent: :purge
    end
  end
end
