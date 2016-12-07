class RenameGameLobbyToLobby < ActiveRecord::Migration[5.0]
  def change
    rename_table :game_lobbies, :lobbies

    rename_column :game_lobby_users, :game_lobby_id, :lobby_id
    rename_column :games, :game_lobby_id, :lobby_id
    rename_column :messages, :game_lobby_id, :lobby_id
  end
end
