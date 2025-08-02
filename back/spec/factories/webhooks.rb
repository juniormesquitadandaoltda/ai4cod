FactoryBot.define do
  factory :webhook do
    sequence(:url) { |n| "https://localhost/#{n}" }
    actived { true }
    resource { :collaborator }
    event { :create }
    subscription { Subscription.first || create(:subscription) }
  end
end
