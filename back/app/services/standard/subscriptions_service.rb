module STANDARD
  class SubscriptionsService < ApplicationService
    attr_accessor :subscription

    validates :subscription, presence: true, persistence: true

    private

    def run
      create_fields

      @result = true
    end

    def create_fields
      {
        task: {
          stage: %w[Inicial Vistoria]
        },
        vehicle: {
          brand: %w[FIAT],
          model: %w[MOBI],
          color: %w[Branco],
          fuel: %w[Flex],
          category: %w[Passeio],
          kind: %w[Automóvel]
        }
      }.each do |resource, names|
        names.each do |name, values|
          subscription.fields.create(resource:, name:, values:)
        end
      end
    end
  end
end
