class Invitation < ActiveRecord::Base
  belongs_to :inviter, foreign_key: 'inviter_id', class_name: 'User'
  
  validates :recipient_email_address, presence: true, uniqueness: true
  validates_format_of :recipient_email_address, with: /@[A-Za-z0-9.-]+\./
  validates_presence_of :recipient_name, :message
  
  before_create :generate_token
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
  def clear_token_column
    self.update_column(:token, nil)
  end
end