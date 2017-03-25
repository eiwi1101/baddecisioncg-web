class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :score_limit
      t.integer :lobby_id
      t.integer :winning_user_id
      t.string :status
      t.string :guid
      t.timestamps
    end

    add_index :games, :lobby_id
    add_index :games, :winning_user_id
    add_index :games, :status
    add_index :games, :guid
  end
end
