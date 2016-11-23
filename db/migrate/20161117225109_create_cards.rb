class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :type
      t.text :text
      t.integer :expansion_id
      t.string :uuid
    end

    add_index :cards, :expansion_id
    add_index :cards, :uuid
  end
end
