FactoryBot.define do
  factory :collaborator do
    actived { true }
    subscription { Subscription.first || create(:subscription) }
    user { User.profile_standard.where.not(id: subscription.user_id).first || create(:user) }
  end
end
