FactoryBot.define do
  factory :subscription do
    actived { true }
    sequence(:name) { |n| "Name #{n}" }
    user { User.profile_standard.first || create(:user) }
    due_date { Date.current }
    maximum_records_count { 1_000 }
  end
end
