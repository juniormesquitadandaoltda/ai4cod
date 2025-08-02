FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    policy_terms { true }

    trait :admin do
      profile do
        class << instance
          private

          def config_profile!; end
        end

        :admin
      end
    end
  end
end
