FactoryBot.define do
  factory :field do
    resource { :task }
    name { :stage }
    values { %w[value1] }
    subscription do
      current = Subscription.first || create(:subscription)
      current.fields.destroy_all
      current
    end
  end
end
