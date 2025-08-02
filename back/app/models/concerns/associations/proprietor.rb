module Associations
  module Proprietor
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail

      belongs_to :subscription, counter_cache: true

      has_many :tasks, dependent: :restrict_with_error

      has_many_attached :archives, dependent: :purge
    end
  end
end
