module STANDARD
  class AuditsJob < ApplicationJob
    def perform(audit:, whodunnit:)
      ::PaperTrail.request(whodunnit:) do
        AuditsService.new(
          audit:
        ).call
      end
    end
  end
end
