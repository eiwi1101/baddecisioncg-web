class AddGuidToGameLobbyUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :game_lobby_users, :guid, :string
    add_index  :game_lobby_users, :guid
  end
end
