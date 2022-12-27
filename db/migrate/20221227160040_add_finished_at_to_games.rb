class AddFinishedAtToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :finished_at, :timestamp
    add_index :games, :finished_at
  end
end
