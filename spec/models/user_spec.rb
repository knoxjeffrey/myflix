require 'spec_helper'

describe User do
  it { should have_many :reviews }
  it { should have_many(:queue_items).order(list_position: :asc) }
  
  it { should validate_presence_of :email_address }
  it { should validate_presence_of :password }
  it { should validate_presence_of :full_name }
  
  it { should validate_uniqueness_of :email_address }
  
  it { should_not allow_value("test@test").for(:email_address) }
  it { should allow_value("test@test.com").for(:email_address) }
  
  it { should validate_length_of(:password).is_at_least(5) } 
end
