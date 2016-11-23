class CreateExpansions < ActiveRecord::Migration[5.0]
  def change
    create_table :expansions do |t|
      t.string :name
      t.string :uuid
      t.timestamps
    end

    add_index :expansions, :uuid
  end
end
