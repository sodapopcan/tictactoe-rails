require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "#current_game" do
    it "returns the current game" do
      session = create(:session)
      game = create(:game, player_1: session)

      expect(session.reload.current_game).to eq(game)
    end
  end
end
