require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "#current_game" do
    it "returns the current game" do
      session_1 = create(:session)
      session_2 = create(:session)
      game = create(:game, player_1: session_1, player_2: session_2)

      expect(session_1.reload.current_game).to eq(game)
      expect(session_2.reload.current_game).to eq(game)
    end
  end
end
