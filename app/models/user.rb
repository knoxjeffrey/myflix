class User < ActiveRecord::Base
  has_many :reviews, -> { order created_at: :desc }
  has_many :queue_items, -> { order list_position: :asc }
  
  validates :email_address, presence: true, uniqueness: true
  validates_format_of :email_address, with: /@[A-Za-z0-9.-]+\./
  validates :password, presence: true, length: {minimum: 5}
  validates :full_name, presence: true
  
  has_secure_password validations: false
  
  def queue_item_exists?(item)
    self.queue_items.exists?(video_id: item)
  end
  
  def end_of_list
    self.queue_items.count + 1
  end
  
  def owns_queued_item?(item)
    item.user_id == self.id
  end
  
end