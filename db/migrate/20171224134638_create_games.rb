class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :score_board
      t.text :winner
      t.integer :players
      t.integer :game_turn
      t.timestamps
    end
  end
end
