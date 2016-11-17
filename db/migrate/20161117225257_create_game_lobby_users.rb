class CreateGameLobbyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_lobby_users do |t|
      t.integer :game_lobby_id
      t.integer :user_id
      t.boolean :moderator
      t.boolean :admin
    end

    add_index :game_lobby_users, :game_lobby_id
    add_index :game_lobby_users, :user_id
  end
end
