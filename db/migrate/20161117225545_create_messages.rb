class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :game_lobby_id
      t.integer :user_id
      t.text :message
      t.string :guid
      t.timestamps
    end

    add_index :messages, :game_lobby_id
    add_index :messages, :guid
  end
end
