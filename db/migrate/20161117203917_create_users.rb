class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :display_name
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email
  end
end
