class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order list_position: :asc }
  
  validates :email_address, presence: true, uniqueness: true
  validates_format_of :email_address, with: /@[A-Za-z0-9.-]+\./
  validates :password, presence: true, length: {minimum: 5}
  validates :full_name, presence: true
  
  has_secure_password validations: false
  
end