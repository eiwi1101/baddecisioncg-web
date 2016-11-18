# HABTM Table
class CreateUserExpansions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_expansions, id: false do |t|
      t.integer :user_id
      t.integer :expansion_id
    end

    add_index :user_expansions, [:user_id, :expansion_id]
    add_index :user_expansions, [:expansion_id, :user_id]
  end
end
