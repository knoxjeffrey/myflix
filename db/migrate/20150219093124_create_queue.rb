class CreateQueue < ActiveRecord::Migration
  def change
    create_table :queues do |t|
      t.integer :list_position
      t.integer :video_id, :user_id
      
      t.timestamps
    end
  end
end
