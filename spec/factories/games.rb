FactoryBot.define do
  factory :game do
    association :player_1, factory: :session

    trait :in_progress do
      association :player_2, factory: :session
    end

    trait :finished do
      in_progress
      after :create do |game|
        id = game.player_1.id

        game.update(board: [
          id, id, id,
          nil, nil, nil,
          nil, nil, nil
        ])
      end
    end
  end
end
