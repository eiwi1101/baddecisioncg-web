class CreatePlayerCards < ActiveRecord::Migration[5.0]
  def change
    create_table :player_cards do |t|
      t.integer :player_id
      t.integer :card_id
      t.integer :round_id
    end

    add_index :player_cards, :player_id
    add_index :player_cards, :card_id
    add_index :player_cards, :round_id
  end
end
