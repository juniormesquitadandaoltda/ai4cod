# redis = { url: "#{ENV.fetch('REDIS_URL')}/1", size: 1, network_timeout: 1, pool_timeout: 1 }
redis = { url: "#{ENV.fetch('REDIS_URL')}/1", network_timeout: 1, pool_timeout: 1 }

Sidekiq.configure_server { |c| c.redis = redis }
Sidekiq.configure_client { |c| c.redis = redis }
