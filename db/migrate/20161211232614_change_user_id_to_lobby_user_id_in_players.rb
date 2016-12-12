class ChangeUserIdToLobbyUserIdInPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_index :players, :user_id
    rename_column :players, :user_id, :lobby_user_id
    add_index :players, :lobby_user_id
  end
end
