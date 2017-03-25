class AddGuidToGameLobbyUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :lobby_users, :guid, :string
    add_index  :lobby_users, :guid
  end
end
