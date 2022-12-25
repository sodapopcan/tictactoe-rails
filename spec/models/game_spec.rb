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

  describe "#move" do
    let(:game) { create(:game, :in_progress) }
    let(:player_1) { game.player_1 }
    let(:player_2) { game.player_2 }

    it "player 1 can make a move" do
      game.move(player_1, 0)

      expect(game.reload.board).to eq([
        player_1.id, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ])
    end
  end

  describe "#join" do
    it "errors when a third player tries to join a game" do
      game = create(:game, :in_progress)
      new_session = create(:session)

      game.join(new_session)

      expect(game.errors.full_messages.first).to eq("Cannot join game")
    end
  end
end
