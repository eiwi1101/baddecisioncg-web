class CreateGameExpansions < ActiveRecord::Migration[5.0]
  def change
    create_table :game_expansions, id: false do |t|
      t.integer :game_id
      t.integer :expansion_id
    end

    add_index :game_expansions, :game_id
    add_index :game_expansions, :expansion_id
  end
end
