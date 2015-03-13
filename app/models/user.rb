class User < ActiveRecord::Base
  has_many :reviews, -> { order created_at: :desc }
  has_many :queue_items, -> { order list_position: :asc }
  has_many :friendships
  has_many :people_they_are_following, through: :friendships, source: :friend
  has_many :people_following_them, through: :friendships, source: :user
  
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
  
  def follows?(another_user)
    self.friendships.exists?(friend: another_user)
  end
  
  def cannot_follow?(another_user)
    self == another_user || (self.follows?(another_user))
  end
  
  def generate_token
    self.update_column(:token, SecureRandom.urlsafe_base64)
  end
end