require 'rails_helper'

RSpec.describe Game, type: :model do
  it "creates an empty board" do
    game = Game.create(player_1: create(:session))

    expect(game.board).to eq([
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ])
  end

  it "errors when a third player tries to join a game" do
    game = create(:game, :in_progress)
    new_session = create(:session)

    game.join(new_session)

    expect(game.errors.full_messages.first).to eq("Cannot join game")
  end
end
