FactoryBot.define do
  factory :proprietor do
    name { 'Name' }
    email { 'proprietor@email.com' }
    subscription { Subscription.first || create(:subscription) }
  end
end
