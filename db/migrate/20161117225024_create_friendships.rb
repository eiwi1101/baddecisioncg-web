# HABTM Table
class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships, id: false do |t|
      t.integer :user_id
      t.integer :friend_user_id
    end
  end

  add_index :friendships, :user_id
  add_index :friendships, :friend_user_id
end
