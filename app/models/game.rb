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

  def join(new_player)
    errors.add(:base, "Cannot join game") and return if player_2.present?

    update(player_2: new_player)
  end

  def move(player, board_index)
    errors.add(:base, "Waiting for another player") and return unless player_1 && player_2
    errors.add(:base, "It's not your turn") and return unless player == current_turn
    errors.add(:base, "Space already taken") and return if board[board_index]

    self.board[board_index] = player.id

    save
  end

  def over?
    winner.present?
  end

  def winner
    WIN_CONDITIONS.each do |(a, b, c)|
      [player_1, player_2].each do |player|
        return player if board[a] == player.id && board[b] == player.id && board[c] == player.id
      end
    end

    nil
  end

  def current_turn
    board.compact.count % 2 == 0 ? player_1 : player_2
  end
end
