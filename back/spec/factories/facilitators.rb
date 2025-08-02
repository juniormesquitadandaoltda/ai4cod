FactoryBot.define do
  factory :facilitator do
    name { 'Name' }
    email { 'facilitator@email.com' }
    subscription { Subscription.first || create(:subscription) }
  end
end
