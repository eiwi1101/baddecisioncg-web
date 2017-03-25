class CreateGameLobbyUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :lobby_users do |t|
      t.integer :lobby_id
      t.integer :user_id
      t.boolean :moderator
      t.boolean :admin
      t.datetime :deleted_at
    end

    add_index :lobby_users, :lobby_id
    add_index :lobby_users, :user_id
  end
end
