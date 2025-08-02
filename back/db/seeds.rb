ENV['RAILS_SEED'] = 'true'
PaperTrail.enabled = false

ApplicationRecord.connection.transaction do
  1.times do |i|
    load "db/seeds/#{(i + 1).to_s.rjust(3, '0')}.rb"
  end
rescue
  ApplicationRecord.connection.rollback_transaction
end

ENV.delete('RAILS_SEED')
PaperTrail.enabled = true
