class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :try1
      t.integer :try2
      t.integer :turn
      t.integer :score
      t.string :status

      t.references :player, foreign_key: true
      t.references :game, foreign_key: true
      t.timestamps
    end
  end
end
