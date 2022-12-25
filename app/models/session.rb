class Session < ApplicationRecord
  def current_game
    Game.where(player_1: self).or(Game.where(player_2: self)).first
  end
end
