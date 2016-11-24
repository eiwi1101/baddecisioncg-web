class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :score
      t.integer :order
      t.string :guid
      t.datetime :deleted_at
    end

    add_index :players, :game_id
    add_index :players, :user_id
    add_index :players, :guid
  end
end
