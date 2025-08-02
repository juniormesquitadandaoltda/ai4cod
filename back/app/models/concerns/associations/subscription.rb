module Associations
  module Subscription
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail

      belongs_to :user, counter_cache: true

      has_many :collaborators, dependent: :restrict_with_error
      has_many :webhooks, dependent: :restrict_with_error
      has_many :calleds, dependent: :restrict_with_error
      has_many :fields, dependent: :restrict_with_error
      has_many :proprietors, dependent: :restrict_with_error
      has_many :facilitators, dependent: :restrict_with_error
      has_many :vehicles, dependent: :restrict_with_error
      has_many :tasks, dependent: :restrict_with_error
      has_many :archives, dependent: :restrict_with_error

      delegate :uuid, to: :user, allow_nil: true, prefix: true
    end
  end
end
