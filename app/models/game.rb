class Game < ApplicationRecord
  belongs_to :player_1, class_name: "Session"
  belongs_to :player_2, class_name: "Session", required: false
end
