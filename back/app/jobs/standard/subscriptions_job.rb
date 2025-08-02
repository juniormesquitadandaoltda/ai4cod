module STANDARD
  class SubscriptionsJob < ApplicationJob
    def perform(subscription:, whodunnit:)
      ::PaperTrail.request(whodunnit:) do
        SubscriptionsService.new(
          subscription:
        ).call
      end
    end
  end
end
