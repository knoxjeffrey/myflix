class User < ActiveRecord::Base
  
  validates :email_address, presence: true, uniqueness: true
  validates_format_of :email_address, with: /@./
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :full_name, presence: true
  
  has_secure_password validations: false
  
end