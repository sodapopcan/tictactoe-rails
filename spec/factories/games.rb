FactoryBot.define do
  factory :game do
    association :player_1, factory: :session
  end
end
