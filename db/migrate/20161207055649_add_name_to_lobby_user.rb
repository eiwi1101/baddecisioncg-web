class AddNameToLobbyUser < ActiveRecord::Migration[5.0]
  def change
    add_column :lobby_users, :name, :string
  end
end

