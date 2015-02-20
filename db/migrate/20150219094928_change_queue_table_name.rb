class ChangeQueueTableName < ActiveRecord::Migration
  def change
    rename_table :queues, :queue_items
  end
end
