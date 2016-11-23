class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :number
      t.integer :bard_player_id
      t.integer :winning_player_id
      t.integer :fool_pc_id
      t.integer :crisis_pc_id
      t.integer :bad_decision_pc_id
      t.integer :story_card_id
      t.string :status
      t.string :guid
      t.timestamps
    end

    add_index :rounds, :game_id
    add_index :rounds, :winning_player_id
    add_index :rounds, :guid
  end
end
