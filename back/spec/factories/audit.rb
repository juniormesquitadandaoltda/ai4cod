FactoryBot.define do
  factory :audit do
    item { Subscription.first || create(:subscription) }
    whodunnit { instance.item.user }
    event { :create }
    object_changes { { id: [nil, 1] } }
  end
end
