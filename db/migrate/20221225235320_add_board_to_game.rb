class AddBoardToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :board, :json, default: []
  end
end
