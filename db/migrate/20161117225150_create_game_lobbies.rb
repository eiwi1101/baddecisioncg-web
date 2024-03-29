class CreateGameLobbies < ActiveRecord::Migration[5.0]
  def change
    create_table :lobbies do |t|
      t.string :name
      t.boolean :private
      t.string :token
      t.string :password
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :lobbies, :token
  end
end
