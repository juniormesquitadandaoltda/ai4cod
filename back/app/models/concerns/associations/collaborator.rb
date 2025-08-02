module Associations
  module Collaborator
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail

      belongs_to :user, counter_cache: :collaborations_count
      belongs_to :subscription, counter_cache: true

      delegate :uuid, to: :user, allow_nil: true, prefix: true
      delegate :user, to: :subscription, allow_nil: true, prefix: true
    end
  end
end
