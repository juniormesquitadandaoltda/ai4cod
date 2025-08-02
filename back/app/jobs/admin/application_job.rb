module ADMIN
  class ApplicationJob < ActiveJob::Base
    queue_as :admin
  end
end
