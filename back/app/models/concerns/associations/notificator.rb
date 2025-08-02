module Associations
  module Notificator
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail

      has_many :notifications, dependent: :restrict_with_error
    end
  end
end
