FactoryBot.define do
  factory :task do
    name { 'Emplacamento' }
    stage { 'Inicial' }
    next_stage { 'Vistoria' }
    scheduling_at { '2025-01-01 09:00:00' }
    shared { true }
    notes { '1º Emplacamento' }
    subscription { Subscription.first || create(:subscription) }
    vehicle { Vehicle.first || create(:vehicle, subscription:) }
    facilitator { Facilitator.first || create(:facilitator, subscription:) }
    proprietor { Proprietor.first || create(:proprietor, subscription:) }
  end
end
