module STANDARD
  class ApplicationJob < ActiveJob::Base
    queue_as :standard

    def self.perform(**args)
      Rails.env.test? || ENV['RAILS_SEED'] == 'true' ? new.perform(**args) : perform_later(**args)
    end
  end
end
