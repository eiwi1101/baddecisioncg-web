class RenameGameLobbyUserToLobbyUser < ActiveRecord::Migration[5.0]
  def change
    rename_table :game_lobby_users, :lobby_users
  end
end
