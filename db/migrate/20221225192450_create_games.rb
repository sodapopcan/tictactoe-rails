class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :player_1, null: false, foreign_key: { to_table: :sessions }
      t.references :player_2, foreign_key: { to_table: :sessions }

      t.timestamps
    end
  end
end
