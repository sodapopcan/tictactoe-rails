class Game < ApplicationRecord
  BOARD = (0..8).map { nil }.freeze

  belongs_to :player_1, class_name: "Session"
  belongs_to :player_2, class_name: "Session", required: false

  before_create { self.board = BOARD.dup }

  def join(player_2)
    errors.add(:base, "Cannot join game") and return if player_2

    self.player_2 = player_2
  end
end
