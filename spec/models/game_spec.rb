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

  describe "#join" do
    it "errors when a third player tries to join a game" do
      game = create(:game, :in_progress)
      new_session = create(:session)

      game.join(new_session)

      expect(game.errors.full_messages.first).to eq("Cannot join game")
    end

    it "returns true when sucessfully joining a game" do
      game = create(:game)
      new_session = create(:session)

      game.join(new_session)

      expect(game.player_2).to eq(new_session)
    end
  end

  describe "#move" do
    context "with one player" do
      it "requires two players before any move may be made" do
        player_1 = create(:session)
        game = create(:game, player_1: player_1)

        game.move(player_1, 6)

        expect(game.errors.full_messages).to include("Waiting for another player")
      end
    end

    context "with both players" do
      let(:game) { create(:game, :in_progress) }
      let(:player_1) { game.player_1 }
      let(:player_2) { game.player_2 }

      it "allows players to make their moves in turn" do
        game.move(player_2, 0)
        expect(game.errors.full_messages.first).to eq("It's not your turn")

        game.move(player_1, 0)
        expect(game.board).to eq([
          player_1.id, nil, nil,
          nil, nil, nil,
          nil, nil, nil
        ])

        game.move(player_1, 1)
        expect(game.errors.full_messages.first).to eq("It's not your turn")

        game.move(player_2, 7)
        expect(game.board).to eq([
          player_1.id, nil, nil,
          nil, nil, nil,
          nil, player_2.id, nil
        ])
      end

      it "does not allow playing on an already taken space" do
        game.move(player_1, 1)
        game.move(player_2, 1)

        expect(game.errors.full_messages.first).to eq("Space already taken")
      end
    end

    context "when game is over" do
      it "does not allow moves" do
        game = create(:game, :finished)

        game.move(game.player_1, 0)

        expect(game.errors.full_messages.first).to eq("The game is over")
      end
    end
  end

  describe "#over?" do
    it "return true if the game is over" do
      game = create(:game, :finished)

      expect(game.over?).to be true
    end
  end

  describe "#winner" do
    it "returns nil if no winner yet" do
      game = create(:game, :in_progress)

      expect(game.winner).to be_nil
    end

    it "exhaustively checks all the win conditions" do
      [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [6, 4, 2], [0, 4, 8]
      ].each do |(a, b, c)|
        game = create(:game, :in_progress)
        [game.player_1, game.player_2].each do |player|
          game.board[a] = player.id
          game.board[b] = player.id
          game.board[c] = player.id
          game.save

          expect(game.winner).to eq(player)
        end
      end
    end
  end
end
