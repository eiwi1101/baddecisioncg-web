# HABTM Table
class CreateRoundPlayerCards < ActiveRecord::Migration[5.0]
  def change
    create_table :round_player_cards, id: false do |t|
      t.integer :round_id
      t.integer :player_card_id
    end

    add_index :round_player_cards, :round_id
    add_index :round_player_cards, :player_card_id
  end
end
