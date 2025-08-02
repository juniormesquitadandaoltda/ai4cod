# if %w[production sandbox playground].include?(Rails.env) && ENV['WORKER_CONCURRENCY']
#   require 'action_mailer'

#   ActiveJob::TrafficControl.client = ConnectionPool.new(size: ENV['WORKER_CONCURRENCY'] || '1', timeout: 5) { Redis.new }

#   module ActionMailer
#     class MailDeliveryJob
#       throttle threshold: ENV['SMTP_THRESHOLD'] || '1', period: 2.seconds
#     end
#   end
# end
