class Game < ApplicationRecord
  BOARD = (0..8).map { nil }.freeze
  WIN_CONDITIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [6, 4, 2], [0, 4, 8]
  ].freeze

  belongs_to :player_1, class_name: "Session"
  belongs_to :player_2, class_name: "Session", required: false

  before_create { self.board = BOARD.dup }

  def join(player_2)
    errors.add(:base, "Cannot join game") and return if player_2

    self.player_2 = player_2
  end

  def move(player, board_index)
    self.board[board_index] = player.id
    save
  end
end
