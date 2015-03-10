class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id, :friend_id
      
      t.timestamps
    end
  end
end
