FactoryBot.define do
  factory :game do
    association :player_1, factory: :session

    trait :in_progress do
      association :player_2, factory: :session
    end
  end
end
