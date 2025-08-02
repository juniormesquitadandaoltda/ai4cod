FactoryBot.define do
  factory :called do
    subject { 'Subject' }
    message { 'Message' }
    subscription { Subscription.first || create(:subscription) }
  end
end
